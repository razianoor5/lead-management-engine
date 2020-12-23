# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotSaved, with: :record_not_save
  rescue_from ActiveRecord::RecordNotDestroyed, with: :record_not_destroyed

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[role name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[role name])
  end

  def error_occurred
    render file: Rails.root.join('/public/404.html'), layout: false, status: :not_found
  end

  def user_not_authorized(_exception)
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to leads_path
  end

  def record_not_save(_exception)
    flash[:alert] = 'couldn\'t save the record'
    redirect_to leads_path
  end

  def record_not_destroyed(_exception)
    flash[:alert] = 'couldn\'t destroy the record'
    redirect_to leads_path
  end

  def after_sign_in_path_for(_resource)
    if current_user.super_admin?
      rails_admin_path
    else
      leads_path
    end
  end
end
