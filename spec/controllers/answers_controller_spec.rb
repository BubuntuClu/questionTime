require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }


  describe 'Get #new' do
    before { get :new, params: { question_id: question } }

    it 'assings a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders a new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }
          .to change(question.answers, :count).by(1)
      end

      it 'redirects to the question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid data' do
      it 'does not save a new answer in database' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }
          .to_not change(Answer, :count)
      end

      it 'redirects to the question' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'delete the answer' do
      answer
      expect { delete :destroy, question_id: question, id: answer }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, question_id: question, id: answer
      expect(response).to redirect_to question
    end
  end
end
