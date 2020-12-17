# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]
  before_action :authenticate_user!
  # POST /comments
  def create
    # @commentable = Phase.find(params[:phase_id])
    @lead = Lead.find(params[:lead_id])
    @comment = @lead.comments.new(comment_params)

    authorize @comment
    @comment.save
    redirect_to [@lead], notice: 'Your Comment was successfully created.'
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
