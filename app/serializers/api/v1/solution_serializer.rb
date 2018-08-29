class Api::V1::SolutionSerializer < Api::V1::BaseSerializer
  attributes :id, 
  			 :content, 
  			 :question_id, 
         :survey_id, 
  			 :solution_rates, 
  			 :video, 
  			 :image
  			 
  belongs_to :survey, dependent: :destroy
  belongs_to :question, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
end