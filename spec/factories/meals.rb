FactoryGirl.define do
  factory :meal do
    user
    taken_at Time.now
    calories 800
  end
end
