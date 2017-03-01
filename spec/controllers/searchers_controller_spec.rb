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

    # it 'valid params' do
    #   expect(Searches).to receive(:request).with('','all')
    #   get :index, params: { search_type:'all', search: 'all' }
    # end
  end
end
