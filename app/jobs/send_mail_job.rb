# frozen_string_literal: true

class SendMailJob < ApplicationJob
  queue_as :default

  def perform(user, phase)
    UserMailer.phase_assignment_email(user, phase).deliver_now
  end
end
