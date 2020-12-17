# frozen_string_literal: true

class PhasePolicy < ApplicationPolicy
  attr_reader :user, :phase

  def initialize(user, phase)
    @user = user
    @phase = phase
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    owner?
  end

  def new?
    create?
  end

  def update?
    owner?
  end

  def edit?
    owner?
  end

  def destroy?
    owner?
  end

  def engineer?
    phase_assignee?
  end

  def complete?
    @user.id == @phase.lead.user_id || @phase.users.where(role: 'technical_manager').exists?(@user.id)
  end

  private

  def owner?
    @user.id == @phase.lead.user_id
  end

  def phase_assignee?
    @phase.users.where(role: 'technical_manager').exists?(@user.id)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
