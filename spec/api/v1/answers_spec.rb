require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if there is wrong access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '123'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at best rating).each do |field|
        it "answer object contains #{field}" do
          expect(response.body).to be_json_eql(answer.send(field.to_sym).to_json).at_path("0/#{field}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:answer) { create(:answer) }
    let!(:answer_attachment) { create(:answer_attachment, attachmentable: answer) }
    let!(:comment) { create(:answer_comment, commentable: answer) }

    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if there is wrong access_token' do
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: '123'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |field|
        it "answer object contains #{field}" do
          expect(response.body).to be_json_eql(answer.send(field.to_sym).to_json).at_path("#{field}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body created_at updated_at).each do |field|
          it "contains #{field}" do
            expect(response.body).to be_json_eql(comment.send(field.to_sym).to_json).at_path("comments/0/#{field}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it "contains url" do
          expect(response.body).to be_json_eql(answer_attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if there is wrong access_token' do
        post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: '123' }
        expect(response.status).to eq 401
      end
    end

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
  end
end
