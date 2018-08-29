class Api::V1::SurveysController < Api::V1::BaseController
  include Api::V1::SurveysDoc
  include AverageCalculatorHelper
  # include Api::V1::SurveysDoc
  before_action :set_survey, only: [:show, :edit, :update, :destroy]
  
  def index
    @surveys = Survey.where(user_id: current_user.id).order(:created_at => :desc)
    render json: @surveys, include: [:questions, :solutions]
  end

  def own_created_surveys
    @surveys = current_user.surveys.order(:created_at => :desc)
    json_response(@surveys)
  end

  def my_assigned_surveys
    @assigned_surveys = AssignedSurvey.select(:id, :user_id, :survey_id, :answered, :evaluated_user_id)
                                        .where(evaluated_user_id: current_user.id)
    # else
    #   @assigned_surveys = AssignedSurvey.joins(:survey)
    #                                     .select(:id, :user_id, :survey_id, :answered, :evaluated_user_id)
    #                                     .where(surveys: {user_id: current_user.id})
    #                                     .paginate(page: params[:page], per_page: 7)
    #                                     .order('assigned_surveys.created_at DESC')
    # end
  end

  def save_survey_answers
  
  survey = Survey.find_by(id: params[:survey_id])
    assigned_ids = AssignedSurvey.with_answer(true).where(survey_id: survey.id)
    current = SurveyResult.where(assigned_survey_id: assigned_ids).count

    if !survey.present?
      json_response({ errors: "Survey with id #{params[:survey_id]} did not exist yet" }, :unprocessable_entity)
      return
    end
    owner_id = survey.user_id
    if current_user.id == owner_id
      p '----------------------------------------------'
        puts 'IF OWNER SURVEY TRY ANSWER?'
      p '----------------------------------------------'
      return json_response({errors: 'you cannot reply to your own survey'}, :unprocessable_entity)
    end

    user_already_answered = survey.assigned_surveys.with_answer(true).where(evaluated_user_id: current_user.id).any?
    if user_already_answered
      p '----------------------------------------------'
      puts 'THIS USER ALREADY ANSWERED TO THIS SURVEY'
      p '----------------------------------------------'
      return json_response({errors: 'you have already been answered'}, :unprocessable_entity)
    end
    
    max = survey.max_participants_count
    if current >= survey.max_participants_count
      json_response({ errors: "Survey limit reached or exceeded max participants count #{max}, already answered #{current}" }, :unprocessable_entity)
      return
    end

    @as = AssignedSurvey.new(
                        survey_id: params[:survey_id],
                        user_id: params[:user_id],
                        evaluated_user_id: current_user.id,
                        answered: false)
    if @as.save
      @sr = SurveyResult.create(
                                assigned_survey_id: @as.id, 
                                answer_solution_id: params[:answer_solution_id],
                                answer_solution_rates: params[:answer_solution_rates],
                                answer_solution_feedback: params[:answer_solution_feedback])
      if @sr.save
        solution = Solution.find_by(id: @sr.answer_solution_id)
        solution.feedbacks.create(:user_id => current_user.id, 
                                  :survey_id => solution.survey_id,
                                  :question_id => solution.question_id,
                                  :content => @sr.answer_solution_feedback)

        solution_rates = solution.solution_rates
        answer_solution_rates = @sr.answer_solution_rates
        if solution_rates.empty?
          puts "----------------RATES EMPTY----------------"
          solution_rates = @sr.answer_solution_rates
          solution.solution_rates = solution_rates
          puts "----------------RATES NOW ----------------"
          p solution_rates
          p solution.solution_rates
          solution.save
          @as.update(answered: true)
          puts "----------------ANSWERED???----------------"
          puts @as.answered
          puts "-------------------------------------------"
          @as.save
        else 
          hash_list = []        
          hash_list << solution_rates
          hash_list << answer_solution_rates
          puts "---------------HASH LIST---------------"
          puts hash_list
          puts "---------------------------------------"        

          puts "---------------AVERAGE LIST---------------"
          average = calc_average(hash_list)
          p '---------------FINAL RESULT---------------'
          p average
          puts "---------------------------------------"  
          solution.solution_rates = average
          solution.save
          @as.update(answered: true)
          puts "----------------ANSWERED???----------------"
          puts @as.answered
          puts "--------------------------------------------"
          @as.save
        end
        solution.save
        survey.respondents_count = survey.assigned_surveys.with_answer(true).count
        survey.save

        if !survey.survey_identifier
          survey.survey_identifier = SecureRandom.hex(10)
          survey.save
        end

        price = ((survey.cost_per_user * 100) / 2)
        
        transfer = Stripe::Transfer.create({
          :amount => price.to_i,
          :currency => "usd",
          :destination => current_user.stripe_account_id,
          :description => "Reward for the passed Survey",
          :metadata => {'survey_identifier' => survey.survey_identifier},
          :transfer_group => "#{survey.id}"
        })


        json_response({ message: 'Success' }, :created)
      else
        json_response({ errors: @sr.errors }, :unprocessable_entity)
      end
    else
      json_response({ errors: @as.errors }, :unprocessable_entity)
    end
  end

  def test_result
    surv = Survey.last
    results_count = AssignedSurvey.with_answer(true).where(survey_id: surv.id).count
    assigned_ids = AssignedSurvey.with_answer(true).where(survey_id: surv.id)
    total_results = SurveyResult.where(assigned_survey_id: assigned_ids)
    # p AssignedSurvey.with_answer(true).any? {|v| v.survey_id == surv.id}
    solutions_ids = surv.solutions.pluck(:id)
    survey_results = total_results.where(answer_solution_id: [solutions_ids])
    answered_ids = []
    survey_results.each do |key,value|

    answered_ids << key.answer_solution_id
    end

    puts "-----------solutions_ids----------------"
    puts solutions_ids
    puts "----------------------------------------"

    puts "----------answered_ids------------------"
    p answered_ids
    puts "----------------------------"
    b = Hash.new(0)
    answered_ids.each do |v|
      b[v] += 1
    end
    puts '++++' 
    puts b.to_json
    data = []
    b.each do |k, v|
      puts "#{k} appears #{v} times"
      data << {solution_id:k, percentage: ((v.to_f / total_results.count) * 100)}
    end
    p data.as_json

    puts "----------GROUPED IDS WITH SAME VALUE------------------"
    group = answered_ids.group_by{|x| x}.values
    p group
    p ' count '
    p group.count
    puts "-------------------------------------------------------"

    some = []
    group.each_with_index {|val, index| 
      percentage = ((val.count.to_f / total_results.count) * 100)
      some << percentage
    }
    p "------"
    puts some.to_json

    render json: {results_count: results_count, 
                  survey_solutions_ids: solutions_ids, 
                  survey_result: survey_results, surv: surv}

  end

  
  def my_responded_ideas
    @assigned_surveys = AssignedSurvey.with_answer(true).where(evaluated_user_id: current_user.id)
    assigned_ids = @assigned_surveys.pluck(:id)
    s = @assigned_surveys.pluck(:survey_id)
    surveys = Survey.where(id: [s])
    
    results = SurveyResult.where(assigned_survey_id: assigned_ids).pluck(:answer_solution_id)
    solutions_results = Solution.where(id: results)


    render json: {date: @assigned_surveys, survey: surveys, answered_solutions: solutions_results}
  end


  def result
    @assigned_surveys = AssignedSurvey.with_answer(true).where(evaluated_user_id: current_user.id)
    assigned_ids = @assigned_surveys.pluck(:id)
    ids = @assigned_surveys.pluck(:survey_id)
    surveys = Survey.where(id: [ids])

    results = SurveyResult.with_assigned_survey_id([assigned_ids])

    r = results.pluck(:answer_solution_rates)
    r.each do |p|
      puts p.flatten
    end

    results.each do |key,value|
      p key
      if value.is_a?(Hash)
        value.each do |k,v|
          p k
          p v
        end
      else
      end
    end

    # rslt = SurveyResult.assigned_surveys.with_answer(true)

    render json: { results: results, r: r}
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = current_user.surveys.new(survey_params)
    
    @questions = @survey.questions
    @solutions = @survey.solutions

    @questions.each do |question|
      new_question = Question.new(question['question_id'])
      new_question.save
    end
    
    @questions[0].solutions << @solutions
    @survey.user = current_user
    if @survey.save
      puts "------------------SEND NOTIFICATIONS FROM CREATE METHOD------------------"
        send_notifications_to_users(@survey)
      puts "--------------------------------------------------------------------------"
        render json: @survey, status: :created
      else
        json_response({ errors: @survey.errors }, :unprocessable_entity)
    end
  end

  def make_charge(total_price)
    price = (total_price * 100).to_i
    card = {number: "4242424242424242", exp_month: 5, exp_year: 2022, cvc: "314" }
    puts "------------------MAKE CHARGE------------------"
    # customer = Stripe::Customer.create(:source => "tok_visa")
    token = CreditCardService.new(current_user.id, card).create_credit_card
    # def initialize(amount:, customer:, currency:, source: ,title:)
    charge = Charge.new(amount: price, 
                        customer: current_user.stripe_id, 
                        currency: 'usd',
                        source: token,
                        title: 'Submitted payment')
    charge.save
    # charge = Stripe::Charge.create({
    #   amount: 999,
    #   currency: 'usd',
    #   description: 'Submitted payment',
    #   source: token,
    # })
    puts "------------------END CHARGE------------------"
  end

  def send_notifications_to_users(survey)
    @query = survey.target_audience.delete_if { |k,v| v.downcase == "include all"}
    @founded_profiles = Profile.where.not(user_id: current_user).where(@query)
    p '-----------FOUNDED PROFILES WITH QUERY PARAMS-------------------'
    puts @founded_profiles.to_json
    @teokens = @founded_profiles.all.map(&:user).pluck(:push_token).compact
    s = survey.as_json
    q = survey.questions.as_json
    ss = survey.solutions.as_json

    puts "__________________TOKENS TO SEND______________"
    puts @teokens
    puts "______________________END____________________________"
    
    @teokens.each do |token|
        notification = Houston::Notification.new(device: token)
        notification.alert    = {
          title:  "Title",
          body:   "New idea has been submitted. Please respond & get paid!"
        }
        notification.custom_data = {survey: s, questions: q, solutions: ss}
        notification.sound = 'chime.aiff'
        IosNotificationService.send_me(notification.message)
    end
  end

  def show
    surv = @survey
    results_count = AssignedSurvey.with_answer(true).where(survey_id: surv.id).count
    assigned_ids = AssignedSurvey.with_answer(true).where(survey_id: surv.id)
    total_results = SurveyResult.where(assigned_survey_id: assigned_ids)
    # p AssignedSurvey.with_answer(true).any? {|v| v.survey_id == surv.id}
    solutions_ids = surv.solutions.pluck(:id)
    survey_results = total_results.where(answer_solution_id: [solutions_ids])
    
    answered_ids = []
    survey_results.each do |key,value|
      answered_ids << key.answer_solution_id
    end

    puts "-----------solutions_ids-----------------"
    puts solutions_ids
    puts "-----------------------------------------"

    puts "------------answered_ids-----------------"
    p answered_ids
    puts "-----------------------------------------"
    
    solution_votes_count = Hash.new(0)
    
    answered_ids.each do |v|
      solution_votes_count[v] += 1
    end
    puts solution_votes_count.to_json
    
    data = []
    solution_votes_count.each do |key, value|
      puts "#{key} appears #{value} times"
      data << {solution_id: key, percentage: ((value.to_f / total_results.count) * 100)}
    end
    p data.as_json

    render json: {
      survey: @survey.as_json( :only => [:id, :title, :user_id, :target_audience]),
      percentage: data,
      respondents_count: total_results.count,
      solutions: @survey.solutions.as_json(:include => { :feedbacks => {:only => [:id, :question_id, :user_id, :solution_id, :content] } }, 
                                           :only => [:id, :question_id, :content, :image, :video, :solution_rates])
    }
  end


  def edit
    @survey
  end

  def update
    if @survey.update(survey_params)
      render json: 'Success'
    else
      render :edit
    end
  end

  def destroy
    @survey.destroy
  end

  private

  def survey
    @survey ||= Survey.find(params[:id])
  end

  def survey_build
    @survey = Survey.new
    @questions = Array.new(5) { @survey.questions.new }
    @questions.each do |question|
      question.answers = Array.new(4) { @survey.answers.new }
    end
  end

  def set_survey
    @survey = Survey.find(params[:id])
  end

  def survey_params
    params.permit(:id,
                  :title,
                  :user_type,
                  :user_id,
                  :survey_type,
                  :status,
                  :max_participants_count,
                  :cost_per_user,
                  :total_price,
                                   
                  target_audience:
                  [
                    :gender, 
                    :age_category, 
                    :hh_income,
                    :education_level, 
                    :life_style,
                    :relationship_status, 
                    :life_stage, 
                    :home_ownership
                  ],

                  questions_attributes:
                  [
                    :id, 
                    :survey_id, 
                    :user_id, 
                    :content, 
                    :_destroy
                  ], 

                  solutions_attributes:
                  [
                    :id, 
                    :question_id, 
                    :survey_id, 
                    :content,  
                    :image, 
                    :video, 
                    :_destroy,

                    solution_rates: 
                    [
                      :id, 
                      :relevance,
                      :usefulness,
                      :uniqueness,
                      :shareability,
                      :purchase_intent
                    ],
                      
                    feedbacks_attributes: [:id, :content]
                  ]
                )
  end
end