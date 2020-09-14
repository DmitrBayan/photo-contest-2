# frozen_string_literal: true

class PostMailer < ApplicationMailer
  default from: 'noreply@bayan-photo-contest.com'

  def state_change_email(post)
    @user = post.user
    return if @user.email.blank?

    @post = post
    @state = post.aasm_state
    mail to: @user.email, subject: 'State changed'
  end
end
