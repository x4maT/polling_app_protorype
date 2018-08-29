class Api::V1::QuestionSerializer < Api::V1::BaseSerializer
  attributes :id, :content
  belongs_to :survey
  has_many :solutions
end