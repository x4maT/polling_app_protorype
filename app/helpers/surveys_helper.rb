module SurveysHelper
  

  def number_of_questions survey
    survey.questions.count
  end

  def number_of_solutions survey
    survey.solutions.count
  end

  def number_of_feedbacks survey
    # survey.solutions.count
  end

  def number_of_attempts survey
    # survey.attempts.count
  end
end