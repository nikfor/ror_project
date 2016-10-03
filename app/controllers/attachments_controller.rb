class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.id == @attachment.attachmentable.user_id
      @attachment.destroy
      flash.now[:notice] = 'File is deleted'
    else
      @destroy_attachment_error = 'Error. You can not delete file'
    end
  end
end
