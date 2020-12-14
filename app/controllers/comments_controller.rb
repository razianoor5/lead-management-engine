# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  # POST /comments
  def create
    if params[:phase_id]
      @commentable = Phase.find(params[:phase_id])
      @lead = Lead.find(params[:lead_id])
    else
      @commentable = Lead.find(params[:lead_id])
    end
    @comment = @commentable.comments.new(comment_params)
    # @comment.user = current_user
    @comment.save
    if params[:phase_id]
      redirect_to [@lead, @commentable], notice: 'Your Comment was successfully created.'
    else
      redirect_to [@commentable], notice: 'Your Comment was successfully created.'
    end
  end

  # # PATCH/PUT /comments/1

  # def update
  #   respond_to do |format|
  #     if @comment.update(comment_params)
  #       format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
  #     else
  #       format.html { render :edit }
  #     end
  #   end
  # end

  # DELETE /comments/1

  def destroy
    @comment.destroy
    if params[:phase_id]
      redirect_to lead_phase_path(id: params[:phase_id]), notice: 'Comment was successfully destroyed.'
    else
      redirect_to lead_path(id: params[:lead_id]), notice: 'Comment was successfully destroyed.'
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
