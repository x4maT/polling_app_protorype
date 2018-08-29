class Api::V1::UserSurveysController < Api::V1::BaseController
	
	def new
	end

	def create
    @survey.create!(survey_params)
    json_response(@todo, :created)
  end

  private

  def survey_params
    params.permit(:id, :user_id, :user_type)
  end
end