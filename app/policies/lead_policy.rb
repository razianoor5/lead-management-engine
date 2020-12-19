# frozen_string_literal: true

class LeadPolicy < ApplicationPolicy
  attr_reader :user, :lead

  def initialize(user, lead)
    @user = user
    @lead = lead
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    business_developer?
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

  def close?
    owner?
  end

  private

  def business_developer?
    user.business_developer?
  end

  def owner?
    @lead.user_id == @user.id
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
