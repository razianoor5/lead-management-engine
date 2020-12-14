# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def phase_assignment_email(user, phase)
    @user = user
    @phase = phase
    # @url = user_phase_url(@user, @phase)
    # mail(to: user.email, subject: 'Phase Assignment')
  end
end
