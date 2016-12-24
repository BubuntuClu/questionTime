FactoryGirl.define do

  sequence :body do |n|
    "This is test body#{n}"
  end
  factory :answer do
    body
    user
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    user
  end
end
