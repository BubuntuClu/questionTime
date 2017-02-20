class AnswerSerializer < ActiveModel::Serializer
  include Additable

  attributes :id, :body, :created_at, :updated_at, :best, :rating
  
end
