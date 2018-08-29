class CompletedSurvey < ApplicationRecord
  belongs_to :survey
  has_many :users_surveys, dependent: :destroy
  has_many :users, through: :users_surveys, dependent: :destroy
end
