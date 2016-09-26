class Account < ActiveRecord::Base
  has_many :users, dependent: :destroy
  belongs_to :owner, class_name: 'User'
end
