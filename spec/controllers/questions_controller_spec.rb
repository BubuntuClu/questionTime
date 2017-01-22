require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  before { @user = create(:user) }
  let(:question) { create(:question, user: @user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new asnwer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }
    
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }
    
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid data' do
      it 'saves a new question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question.where(user: @user), :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid data' do
      it 'does not save a new question in database' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders to show view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'with valid data' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: "New title 10", body: "New long body" }, format: :js
        question.reload
        expect(question.title).to eq "New title 10"
        expect(question.body).to eq "New long body"
      end

      it 'render update template' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid data' do
      before { patch :update, id: question, question: { title: 'new titile', body: nil }, format: :js }
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq "This is test label15"
        expect(question.body).to eq "This is long body text"
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { question }

    context 'Authenticated user' do
      context 'user is author' do
        it 'delete the question' do
          expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
        end

        it 'redirect to index view' do
          delete :destroy, id: question
          expect(response).to redirect_to questions_path
        end
      end

      context 'user is not author' do
        it 'try to delete the question' do
          @user = create(:user)
          sign_in @user
          expect { delete :destroy, id: question }.to_not change(Question, :count)
        end
      end
    end

    context 'Non-authenticated user' do
      it 'delete the question' do
        expect { delete :destroy, id: question }.to change(Question, :count)
      end
    end
  end
end
