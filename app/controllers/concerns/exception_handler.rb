# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotSaved, with: :record_not_save
    rescue_from ActiveRecord::RecordNotDestroyed, with: :record_not_destroyed
    rescue_from ActiveRecord::RecordInvalid, with: :record_not_save
  end

  private

  def user_not_authorized(_exception)
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to redirection_path
  end

  def record_not_save(_exception)
    flash[:alert] = 'couldn\'t save the record'
    redirect_to redirection_path
  end

  def record_not_destroyed(_exception)
    flash[:alert] = 'couldn\'t destroy the record'
    redirect_to redirection_path
  end
end
