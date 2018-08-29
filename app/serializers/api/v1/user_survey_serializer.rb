class Api::V1::UserSurveySerializer < Api::V1::BaseSerializer
  attributes :id, :user_id, :status, :target_audience

  belongs_to :survey
  belongs_to :user

  def self.dump(hash)
	  hash.to_json
	end

	def self.load(hash)
	  (hash || {}).with_indifferent_access
	end
end