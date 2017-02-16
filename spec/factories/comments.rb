FactoryGirl.define do

  sequence :comment_body do |n|
    "This is number #{n} comment"
  end

  factory :comment do
    body = :comment_body
    users_id = user
  end

  # factory :answer_comment do
  #   body = :comment_body
  #   users_id = user.id
  #   answer
  # end

  # factory :question_comment do
  #   body = :comment_body
  #   users_id = user.id
  #   question
  # end
end
