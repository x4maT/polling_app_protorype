class Api::V1::QuestionsController < Api::V1::BaseController
	before_action :set_survey

	def index
		@questions = @survey.questions
		json_response(@questions , :ok)
	end

	def show
		@question = @survey.questions.find(params:[:id])
		json_response(@questions , :ok)
	end

  def new
  end
  
  def create
    @question = @survey.questions.create(question_params)
  end

	private

	def question_params
    	# whitelist params
    	params.require(:question).permit(:id, :survey_id, :content, :user_id, 
                                       solutions_attributes: [:id, :question_id, :survey_id, :survey_id, :content, :_destroy])
  	end

	def set_survey
    	@survey = Survey.find(params[:survey_id])
  	end
end