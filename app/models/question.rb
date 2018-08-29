class Question < ApplicationRecord
	
	# belongs_to :user, optional: true
	belongs_to :survey
	has_many :solutions, dependent: :destroy
	has_many :feedbacks, dependent: :destroy
	accepts_nested_attributes_for :solutions, reject_if: :all_blank, allow_destroy: true
end