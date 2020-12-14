# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to leads_path if current_user&.business_developer?
    redirect_to rails_admin_path if current_user&.super_admin?
  end
end
