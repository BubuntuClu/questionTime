module Additable
  extend ActiveSupport::Concern

  included do
    has_many :attachments
    has_many :comments
  end
end
