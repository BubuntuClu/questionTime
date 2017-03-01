require 'rails_helper'

RSpec.describe SubscribersController, type: :controller do
  before do 
    @user = create(:user) 
    @question = create(:question, user: @user)
    @subscriber = @question.subscribers.first
  end
  sign_in_user


  describe 'POST #create' do
    it 'increase subscribers count for question' do
      expect { post :create, params:{ question_id: @question, format: :js } }.to change(@question.subscribers, :count).by(1)
    end

    it 'render create template' do
      post :create, params:{ question_id: @question, format: :js }
      expect(response).to render_template :create
    end
  end

   describe 'DELETE #destroy' do
    it 'decrease subscribers count for question' do
      expect { delete :destroy, params:{ id: @subscriber.id, format: :js } }.to change(@question.subscribers, :count).by(-1)
    end

    it 'render destroy template' do
      delete :destroy, params:{ id: @subscriber.id, format: :js }
      expect(response).to render_template :destroy
    end
  end
end
