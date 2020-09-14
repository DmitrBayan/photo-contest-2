# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'noreply@bayan-photo-contest.com'

  def state_change_email(user)
    @user = user
    return if @user.email.blank?

    @state = user.aasm_state
    mail to: @user.email, subject: 'State changed'
  end
end
