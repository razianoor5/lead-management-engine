# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_and_authorize_comment, only: :destroy

  # POST /comments

  def create
    @commentable_resouce = Phase.find_by(id: params[:phase_id]) || Lead.find_by(id: params[:lead_id])
    create_and_authorize_comment(@commentable_resouce, comment_params)
    if @commentable_resouce.instance_of?(Phase)
      return redirect_to [@commentable_resouce.lead, @commentable_resouce],
                         notice: 'Comment was created successfully.'
    end
    redirect_to @commentable_resouce, notice: 'Comment was created successfully.'
  end

  # DELETE /comments/1

  def destroy
    @comment.destroy!
    if params[:phase_id]
      redirect_to lead_phase_path(params[:lead_id], params[:phase_id]), notice: 'Comment was successfully destroyed.' and return
    else
      redirect_to lead_path(id: params[:lead_id]), notice: 'Comment was successfully destroyed.' and return
    end
  end

  def redirection_path
    if @comment.commentable_type == 'Phase'
      lead_phase_path(params[:lead_id], params[:phase_id])
    else
      lead_path(id: params[:lead_id])
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_and_authorize_comment
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit!
  end

  def create_and_authorize_comment(commentable, comment_params)
    @comment = commentable.comments.new(comment_params)
    authorize @comment
    @comment.body += " | #{current_user.email}"
    @comment.save!
  end
end
