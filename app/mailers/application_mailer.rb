# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV['default_mail']
  layout 'mailer'
end
