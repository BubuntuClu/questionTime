require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let!(:question) { create(:question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at best rating).each do |field|
        it "answer object contains #{field}" do
          expect(response.body).to be_json_eql(answer.send(field.to_sym).to_json).at_path("0/#{field}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:answer) { create(:answer) }
    let!(:attachment) { create(:answer_attachment, attachmentable: answer) }
    let!(:comment) { create(:answer_comment, commentable: answer) }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Commentable"
    it_behaves_like "API Attachmentable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      %w(id body created_at updated_at).each do |field|
        it "answer object contains #{field}" do
          expect(response.body).to be_json_eql(answer.send(field.to_sym).to_json).at_path("#{field}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let!(:question) { create(:question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid params' do
        before { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }

        it 'return 201 status' do
          expect(response).to be_created
        end

        %w(id body created_at updated_at).each do |field|
          it "answer object contains #{field}" do
            expect(response.body).to have_json_path("#{field}")
          end
        end 

        it 'saved' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }.to change(question.answers, :count).by(1)
        end 
      end

      context 'with invalid params' do        

        it 'return 422 status' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }
          expect(response.status).to eq 422
        end

        it 'not saved' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token } }.to_not change(question.answers, :count)
        end
      end  
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json }.merge(options)
    end
  end
end
