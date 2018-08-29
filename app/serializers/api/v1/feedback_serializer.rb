class Api::V1::FeedbackSerializer < Api::V1::BaseSerializer
	attributes :id, :content, 
			   :user_id, :question_id, 
			   :solution_id, :survey_id, 
			   :content

  	belongs_to :user
  	belongs_to :survey
  	belongs_to :solution
  	has_many :solutions
end