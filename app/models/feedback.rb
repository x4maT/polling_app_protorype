class Feedback < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question, optional: true
  belongs_to :solutions, optional: true
  belongs_to :survey, optional: true
end
