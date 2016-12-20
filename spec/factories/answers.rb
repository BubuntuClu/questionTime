FactoryGirl.define do
  factory :answer do
    body "My long test text"
    user
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    user
  end
end
