class AssignedSurvey < ApplicationRecord
	belongs_to :user
	belongs_to :survey
	belongs_to :evaluated_user, class_name: "User"
	has_many :survey_results, dependent: :destroy

	scope :with_answer, -> (value) { where answered: value }

	def get_survey_by_assigment
		survey = Survey.find(self.survey_id)
	end
end
