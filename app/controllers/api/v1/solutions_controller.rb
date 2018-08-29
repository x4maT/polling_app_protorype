class Api::V1::SolutionsController < Api::V1::BaseController
	
	before_action :set_question

	def index
		@solutions = @question.solutions
		json_response(@solutions , :ok)
	end

	def show
		@solution = @question.solutions.find(params[:id])
		json_response(@solution , :ok)
	end

	def new
		@question.solutions = Solution.new(solution_params)
	end

	private

	def solution_params
		params.require(:solutions).permit(:id, 
										  :survey_id, 
										  :question_id, 
										  :content, 
										  :user_id,
										  :image,
										  :video,
										  solution_rates: [
										  					 :relevance,
                                                             :usefulness,
                                                             :uniqueness,
                                                             :shareability,
                                                             :purchase_intent
                                                            ],
                                            feedbacks_attributes: [
                                                              :id,
                                                              :user_id,
                                                              :survey_id,
                                                              :question_id,
                                                              :solution_id,
                                                              :content
                                                            ]
										)
	end

	def questions_params
    	# whitelist params
    	params.require(:question).permit(
											:id, 
											:survey_id, 
											:question_id, 
										 	:content,
										 	:user_id,
										 	:video,
										 	solution_rates: [:relevance,
                                                             :usefulness,
                                                             :uniqueness,
                                                             :shareability,
                                                             :purchase_intent
                                                            ],
                                            feedbacks_attributes: [
                                                              :id,
                                                              :user_id,
                                                              :survey_id,
                                                              :question_id,
                                                              :solution_id,
                                                              :content
                                                            ]
										)
  	end

	def set_question
    	@question = Question.find(params[:question_id])
  	end
end