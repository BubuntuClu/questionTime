module SerializeCommentable
  extend ActiveSupport::Concern

  included do
    has_many :comments
  end
end
