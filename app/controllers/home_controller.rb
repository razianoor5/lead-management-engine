# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to leads_path if current_user&.business_developer?
    redirect_to leads_path if current_user&.technical_manager?
    redirect_to rails_admin_path if current_user&.super_admin?
    redirect_to new_user_session_path unless current_user
  end
end
