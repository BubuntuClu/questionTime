class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
end
