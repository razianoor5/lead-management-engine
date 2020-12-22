# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def phase_assignment_email(user, phase)
    @user = user
    @phase = phase
    mail(to: @user.email, subject: 'Phase Assigned')
  end
end
