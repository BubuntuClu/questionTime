require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do
    sign_in_user

    context 'user is author' do
      let!(:question) { create(:question, user: @user) }
      let!(:question_attachment) { create(:question_attachment, attachmentable: question) }
      before { question }

      it 'delete file' do
        expect { delete :destroy, params: { id: question_attachment }, format: :js }.to change(question.attachments, :count).by(-1)
      end

      it 'render template' do
        delete :destroy, params: { id: question_attachment }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not author' do
      let(:user2) { create(:user) }
      let!(:question) { user2.questions.create(title: '1111111111', body: 'qweqeqweqweqweqwe') }
      let!(:question_attachment) { create(:question_attachment, attachmentable: question) }

      it 'try to delete the file' do
        expect { delete :destroy, params: { id: question_attachment }, format: :js }.to_not change(Attachment, :count)
      end
    end
  end
end


