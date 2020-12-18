# frozen_string_literal: true
class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  # POST /comments

  def create
    if params[:phase_id]
      @commentable = Phase.find(params[:phase_id])
      @lead = Lead.find(params[:lead_id])
      @comment = @commentable.comments.new(comment_params)
      authorize @comment
      @comment.save
      redirect_to [@lead, @commentable], notice: 'Your Comment was successfully created.'
    else
      @commentable = Lead.find(params[:lead_id])
      @comment = @commentable.comments.new(comment_params)
      authorize @comment
      @comment.save
      redirect_to @commentable, notice: 'Your Comment was successfully created.'
    end
  end

  # DELETE /comments/1

  def destroy
    @comment.destroy
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
end
