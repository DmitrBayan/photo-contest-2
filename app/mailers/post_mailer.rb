# frozen_string_literal: true

class PostMailer < ApplicationMailer
  default from: 'noreply@bayan-photo-contest.com'

  def state_change_email(post, state)
    @user = User.find_by(id: post.user_id)
    return unless @user.email

    @post = post
    @state = state
    mail to: @user.email, subject: 'State changed'
  end
end
