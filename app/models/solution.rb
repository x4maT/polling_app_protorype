require 'carrierwave/orm/activerecord'
class Solution < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :survey
	belongs_to :question, optional: true
	has_many :feedbacks, dependent: :destroy

	accepts_nested_attributes_for :feedbacks, reject_if: :all_blank, allow_destroy: true

	mount_uploader :video, VideoUploader  
	mount_uploader :image, ImageUploader

	def get_content
		solution = {id: self.id, content: self.content, image: self.image_url, video: self.video_url}
		return solution
	end
end
