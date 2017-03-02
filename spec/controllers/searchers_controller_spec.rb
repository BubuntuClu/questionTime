require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe 'GET #index' do
    it 'render create template' do
      get :index, params: { search_type:'all', search: 'all' }
      expect(response).to render_template :index
    end

    it 'invalid params' do
      get :index, params: { search_type:'qwe', search: 'all' }
      expect(response.body).to be_empty
    end

    it 'valid params' do
      expect(controller).to receive(:index)
      get :index, params: { search_type:'all', search: 'all' }
      expect(response).to be_successful
    end
  end
end
