FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    after(:build) { |u| u.skip_confirmation_notification! }
    after(:create) { |u| u.confirm }
    email
    password '123456'
    password_confirmation '123456'
  end

end
