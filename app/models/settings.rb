class Settings < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :daily_calories, numericality: { greater_than: 0 }
end
