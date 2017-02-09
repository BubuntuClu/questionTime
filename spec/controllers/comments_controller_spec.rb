require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  before do 
    @user = create(:user) 
    @question = create(:question, user: @user)
  end
  sign_in_user


  describe 'POST #create' do
    context 'comment for question' do
      it 'increase comments count for question' do
        expect { post :create, params:{ question_id: @question, comment: { body: 'qwe' }, format: :json } }.to change(@question.comments, :count).by(1)
      end

      it 'renders needed fields in JSON' do
        post :create, params:{ question_id: @question, comment: { body: 'qwe' }, format: :json }
        expect(response).to have_http_status :success

        result = JSON.parse(response.body)
        @question.reload
        expect(result["body"]).to eq('qwe')
      end
    end
  end
end
