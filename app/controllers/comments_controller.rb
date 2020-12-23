# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  # POST /comments

  def create
    @commentable_resouce = Phase.find_by_id(params.dig(:phase_id)) || Lead.find_by_id(params.dig(:lead_id))
    create_and_authorize_comment(@commentable_resouce, comment_params)
    return redirect_to [@commentable_resouce.lead, @commentable_resouce] if @commentable_resouce.class.eql?(Phase)
    redirect_to @commentable_resouce, notic: 'successfull'
  end

  # DELETE /comments/1

  def destroy
    @comment.destroy!
    if params[:phase_id]
      redirect_to lead_phase_path(params[:lead_id], params[:phase_id]), notice: 'Comment was successfully destroyed.'
    else
      redirect_to lead_path(id: params[:lead_id]), notice: 'Comment was successfully destroyed.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit!
  end

  def user_not_authorized(_exception)
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to lead_path(params[:lead_id])
  end

  def record_not_save(_exception)
    flash[:alert] = 'couldn\'t save the record'
    redirect_to lead_path(params[:lead_id])
  end

  def record_not_destroyed(_exception)
    flash[:alert] = 'couldn\'t destroy the record'
    redirect_to lead_path(params[:lead_id])
  end

  def create_and_authorize_comment(commentable, comment_params)
    comment = commentable.comments.new(comment_params)
    authorize comment
    comment.body += " | #{current_user.email}"
    comment.save!
  end
end
