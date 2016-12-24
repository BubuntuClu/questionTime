FactoryGirl.define do

  sequence :title do |n|
    "This is test label#{n}"
  end

  factory :question do
    title
    body "This is long body text"
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
