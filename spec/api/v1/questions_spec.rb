require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |field|
        it "question object contains #{field}" do
          expect(response.body).to be_json_eql(question.send(field.to_sym).to_json).at_path("0/#{field}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }
    let!(:attachment) { create(:question_attachment, attachmentable: question) }
    let!(:comment) { create(:comment, commentable: question) }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Commentable"
    it_behaves_like "API Attachmentable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      %w(id title body created_at updated_at).each do |field|
        it "question object contains #{field}" do
          expect(response.body).to be_json_eql(question.send(field.to_sym).to_json).at_path("#{field}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid params' do
        before { post "/api/v1/questions", params: { question: attributes_for(:question), format: :json, access_token: access_token.token } }

        it 'return 201 status' do
          expect(response).to be_created
        end

        %w(id title body created_at updated_at).each do |field|
          it "question object contains #{field}" do
            expect(response.body).to have_json_path("#{field}")
          end
        end 

        it 'saved' do
          expect { post "/api/v1/questions", params: { question: attributes_for(:question), format: :json, access_token: access_token.token } }.to change(Question, :count).by(1)
        end 
      end

      context 'with invalid params' do        

        it 'return 422 status' do
          post "/api/v1/questions", params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }
          expect(response.status).to eq 422
        end

        it 'not saved' do
          expect { post "/api/v1/questions", params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token } }.to_not change(Question, :count)
        end
      end  
    end

    def do_request(options = {})
      post "/api/v1/questions", params: { question: attributes_for(:question), format: :json }.merge(options)
    end
  end
end
