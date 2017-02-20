FactoryGirl.define do
  factory :question_attachment, class: "Attachment" do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'rails_helper.rb')) }
    association :attachmentable, factory: :question
  end

  factory :answer_attachment, class: "Attachment" do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'rails_helper.rb')) }
    association :attachmentable, factory: :answer
  end
end
