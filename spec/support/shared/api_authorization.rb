require 'rails_helper'

shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it 'return 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'return 401 status if there is wrong access_token' do
      do_request(access_token: '123')
      expect(response.status).to eq 401
    end

    describe 'authorization' do
      let(:access_token) { create(:access_token) }

      it 'return 200 status' do
        do_request(access_token: access_token.token)
        expect(response).to be_success
      end
    end
  end
end


shared_examples_for "API Commentable" do
  describe 'authorization' do
    let(:access_token) { create(:access_token) }

    context 'comments' do
      it 'included in question object' do
        do_request(access_token: access_token.token)
        expect(response.body).to have_json_size(1).at_path("comments")
      end

      %w(id body created_at updated_at).each do |field|
        it "contains #{field}" do
          do_request(access_token: access_token.token)
          expect(response.body).to be_json_eql(comment.send(field.to_sym).to_json).at_path("comments/0/#{field}")
        end
      end
    end
  end
end


shared_examples_for "API Attachmentable" do
  describe 'authorization' do
    let(:access_token) { create(:access_token) }

    context 'attachments' do
      it 'included in question object' do
        do_request(access_token: access_token.token)
        expect(response.body).to have_json_size(1).at_path("attachments")
      end

      it "contains url" do
        do_request(access_token: access_token.token)
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
      end
    end
  end
end
