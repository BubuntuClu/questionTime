class AnswerListSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :best, :rating
end
