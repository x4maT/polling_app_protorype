class Api::V1::SurveySerializer < Api::V1::BaseSerializer
  attributes :id, :title, :survey_type, :status, 
             :max_participants_count, :respondents_count, :cost_per_user, 
             :total_price, :target_audience
             
  has_many :questions
  has_many :solutions

  belongs_to :user

  def self.dump(hash)
	  hash.to_json
	end

	def self.load(hash)
	  (hash || {}).with_indifferent_access
	end
end