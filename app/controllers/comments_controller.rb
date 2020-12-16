# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  # POST /comments
  def create
    if current_user.business_developer?
      if params[:phase_id]
        @commentable = Phase.find(params[:phase_id])
        @lead = Lead.find(params[:lead_id])
        @comment = @commentable.comments.new(comment_params)
        @comment.save
        redirect_to [@lead, @commentable], notice: 'Your Comment was successfully created.'
      else
        @commentable = Lead.find(params[:lead_id])
        @comment = @commentable.comments.new(comment_params)
        @comment.save
        redirect_to [@commentable], notice: 'Your Comment was successfully created.'
      end
    else
      @commentable = Phase.find(params[:phase_id])
      @comment = @commentable.comments.new(comment_params)
      @comment.save
      redirect_to [@commentable], notice: 'Your Comment was successfully created.'
    end
  end

  # DELETE /comments/1

  def destroy
    @comment.destroy

    if current_user.business_developer?
      if params[:phase_id]
        redirect_to lead_phase_path(id: params[:phase_id]), notice: 'Comment was successfully destroyed.'
      else
        redirect_to lead_path(id: params[:lead_id]), notice: 'Comment was successfully destroyed.'
      end
    else
      redirect_to phase_path(id: params[:phase_id]), notice: 'Comment was successfully destroyed.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit!
  end
end
