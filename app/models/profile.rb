class Profile < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader

  def full_name
  	@full_name = "#{first_name} #{last_name}"
  end
end
