require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      %w(id email created_at updated_at admin account_confirmed).each do |field|
        it "contains #{field}" do
          expect(response.body).to be_json_eql(me.send(field.to_sym).to_json).at_path(field)
        end
      end

      %w(password encrypted_password).each do |field|
        it "not contains #{field}" do
          expect(response.body).to_not have_json_path(field)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET /other_users' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:user_list) { create_list(:user,3) }

      before { get '/api/v1/profiles/other_users', format: :json, access_token: access_token.token }

      it 'contains list of other user' do
        expect(response.body).to be_json_eql(user_list.to_json)
      end

      it 'contains -1 count user' do
        expect(response.body).to have_json_size(3)
      end

      it 'not me in json' do
        JSON.parse(response.body).each do |user|
          expect(user[:id]).to_not eq me.id
        end
      end
    end
    
    def do_request(options = {})
      get '/api/v1/profiles/other_users', { format: :json }.merge(options)
    end
  end
end
