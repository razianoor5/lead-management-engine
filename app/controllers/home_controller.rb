# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to current_user&.super_admin? ? rails_admin_path : leads_path
  end
end
