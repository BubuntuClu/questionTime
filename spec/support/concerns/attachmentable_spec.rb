require 'rails_helper'

RSpec.shared_examples "attachmentable" do
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for :attachments }
end
