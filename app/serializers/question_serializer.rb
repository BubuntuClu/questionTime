class QuestionSerializer < ActiveModel::Serializer
  include Additable
  
  attributes :id, :title, :body, :created_at, :updated_at
  
end
