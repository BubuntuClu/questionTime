FactoryGirl.define do
  factory :comment do
    body 'test comment'
    association :commentable, factory: :question
  end

  factory :answer_comment, class: "Comment" do
    body 'test comment'
    association :commentable, factory: :answer
  end
end
