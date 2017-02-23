class QuestionSerializer < ActiveModel::Serializer
  include SerializeCommentable
  include SerializeAttachmentable
  
  attributes :id, :title, :body, :created_at, :updated_at
  
end
