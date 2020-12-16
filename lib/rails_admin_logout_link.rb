# frozen_string_literal: true

RailsAdmin::ApplicationHelper

module RailsAdmin
  module ApplicationHelper
    def logout_path
      main_app.send(:sign_out_path)
    rescue StandardError
      false
    end
  end
end

class Devise
  def self.sign_out_via
    :delete
  end
end
