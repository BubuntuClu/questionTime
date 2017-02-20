require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if there is wrong access_token' do
        get '/api/v1/questions', format: :json, access_token: '123'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      # let!(:answer) { create(:answer, question: question) }


      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |field|
        it "question object contains #{field}" do
          expect(response.body).to be_json_eql(question.send(field.to_sym).to_json).at_path("0/#{field}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }
    let!(:question_attachment) { create(:question_attachment, attachmentable: question) }
    let!(:comment) { create(:comment, commentable: question) }

    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if there is wrong access_token' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '123'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |field|
        it "question object contains #{field}" do
          expect(response.body).to be_json_eql(question.send(field.to_sym).to_json).at_path("#{field}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body created_at updated_at).each do |field|
          it "contains #{field}" do
            expect(response.body).to be_json_eql(comment.send(field.to_sym).to_json).at_path("comments/0/#{field}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it "contains url" do
          expect(response.body).to be_json_eql(question_attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end
  end
end
