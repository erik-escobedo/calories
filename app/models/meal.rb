class Meal < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :taken_at, presence: true
  validates :calories, presence: true, numericality: { greater_than: 0 }

  def self.filter(params)
    where('taken_at BETWEEN ? AND ?', params[:date_from], "#{params[:date_to]} 23:59").
      where('taken_at::time BETWEEN ? AND ?', params[:time_from], params[:time_to])
  end
end
