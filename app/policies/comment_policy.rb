class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def create?
    owner?
  end

  def destroy?
    owner?
  end

  private

  def owner?
    if @comment.commentable_type == 'Lead'
      lead = Lead.find(@comment.commentable_id)
      @user.id == lead.user.id
    else
      phase = Phase.find(@comment.commentable_id)
      phase.users.where(role: 'technical_manager').exists?(@user.id)
  end
end
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
