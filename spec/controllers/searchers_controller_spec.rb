require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe 'GET #index' do
    it 'render create template' do
      get :index, params: { search_type:'all', search: 'all' }
      expect(response).to render_template :index
    end

    it 'answer on request' do
      expect(controller).to receive(:index)
      get :index, params: { search_type:'all', search: 'all' }
      expect(response).to be_successful
    end

    it 'calls search' do
      expect(Search).to receive(:run).with('question', 'question', 0)
      Search.run('question', 'question', 0)
    end
  end
end
