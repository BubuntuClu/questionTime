require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  before { @user = create(:user) }
  let!(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  sign_in_user

  # describe 'Get #new' do
  #   before { get :new, params: { question_id: question } }

  #   it 'assings a new answer to @answer' do
  #     expect(assigns(:answer)).to be_a_new(Answer)
  #   end

  #   it 'renders a new view' do
  #     expect(response).to render_template :new
  #   end
  # end

  describe 'POST #mark_best' do
    it 'mark an answer as a best' do
      post :mark_best, params: { id: answer, format: :js }
      expect(assigns(:answer)).to be_best
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }
          .to change(question.answers.where(user: @user), :count).by(1)
      end

      it 'redirects to the question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, user: @user, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid data' do
      it 'does not save a new answer in database' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }
          .to_not change(Answer, :count)
      end

      it 'redirects to the question' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'author of message delete the answer' do
      it 'delete the answer' do
        answer
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author of message trying to delete the answer' do
      it 'trying to delete the answer' do
        answer
        @user = create(:user)
        sign_in @user
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question) }

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: "New long body" }, format: :js
      answer.reload
      expect(answer.body).to eq "New long body"
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end



end
