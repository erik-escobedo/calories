class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :meals, dependent: :destroy

  belongs_to :account
  after_create :create_account, unless: :account_id

  def settings
    Settings.find_or_create_by(user_id: self.id)
  end
  delegate :daily_calories, to: :settings

  def as_json(options = {})
    super(methods: [:daily_calories, :account_manager])
  end

  def account_manager?
    account && account.owner == self
  end
  alias_method :account_manager, :account_manager?

private
  def create_account
    update_attribute(:account, Account.create(owner: self))
  end
end
