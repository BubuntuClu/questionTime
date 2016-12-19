FactoryGirl.define do
  factory :question do
    title "MyString10"
    body "This is long body text"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end