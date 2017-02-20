require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if there is wrong access_token' do
        get '/api/v1/profiles/me', format: :json, access_token: '123'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

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
  end

  describe 'GET /other_users' do
    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get '/api/v1/profiles/other_users', format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if there is wrong access_token' do
        get '/api/v1/profiles/other_users', format: :json, access_token: '123'
        expect(response.status).to eq 401
      end
    end

    
    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:user_list) { create_list(:user,3) }

      before { get '/api/v1/profiles/other_users', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

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
  end
end
