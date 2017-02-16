class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_attachment
  authorize_resource
  respond_to :js
  def destroy
    respond_with(@attachment.destroy) if current_user.author_of?(@attachment.attachmentable)
  end

  private

  def get_attachment
    @attachment = Attachment.find(params[:id])
  end
end
