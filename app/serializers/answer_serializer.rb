class AnswerSerializer < ActiveModel::Serializer
  include SerializeCommentable
  include SerializeAttachmentable

  attributes :id, :body, :created_at, :updated_at, :best, :rating
  
end
