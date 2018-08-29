class SurveyResult < ApplicationRecord
    belongs_to :assigned_survey
    # belongs_to :question
    # belongs_to :solution

	store_accessor :answer_solution_rates, 
                   :gender

    # scope :with_answer, -> (value) { where answered: value }
    scope :with_assigned_survey_id, -> (asid) { where assigned_survey_id: asid }
    scope :with_answer_solution_id, -> (value) { where answer_solution_id: value }
    scope :with_answer_solution_rates, -> (value) { where answer_solution_rates: value }

    def self.all_feedbacks
    	return self.pluck(:answer_solution_feedback)
    end

    def self.high_result(results)
    	results.pluck(:answer_solution_id)
    	
    end
end
