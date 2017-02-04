require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  before do 
    @user = create(:user) 
    @question = create(:question, user: @user)
    @user2 = create(:user)
    sign_in @user2
  end

  describe 'POST #create' do
    context 'vote for question' do
      it 'increase votes for question' do
        expect { post :create, params:{ question_id: @question, value: 'up', format: :json } }.to change(@question.votes.where(users_id: @user2.id), :count).by(1)
      end

      it 'renders needed fields in JSON' do
        post :create, params:{ question_id: @question, value: 'down', format: :json }
        expect(response).to have_http_status :success

        result = JSON.parse(response.body)
        @question.reload
        expect(result["action"]).to eq('vote')
        expect(result["id"]).to eq("question_#{@question.id}")
        expect(result["rating"]).to eq(@question.rating)
      end
    end
  end

  describe 'DELETE #destroy' do
    before{ post :create, params:{ question_id: @question, value: 'up', format: :json  } }
    context 'unvote for question' do
      it 'change votes for question' do
        expect { delete :destroy, params:{ question_id: @question , id: @question }, format: :json }.to change(@question.votes.where(users_id: @user2.id), :count).by(-1)
      end

      it 'renders needed fields in JSON' do
        delete :destroy, params:{ question_id: @question , id: @question  }, format: :json 
        expect(response).to have_http_status :success

        result = JSON.parse(response.body)
        @question.reload
        expect(result["action"]).to eq('unvote')
        expect(result["id"]).to eq("question_#{@question.id}")
        expect(result["rating"]).to eq(@question.rating)
      end
    end
  end
end


