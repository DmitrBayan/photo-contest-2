# frozen_string_literal: true

module ApplicationHelper
  def full_title(title = '')
    full_title = 'PhotoContest'
    "#{title} * #{full_title} *" if title.present?
  end

  def logged?
    current_user.present?
  end

  def current_user?(user)
    user == current_user
  end

  def must_logged
    redirect_to root_path
    flash[:warning] = 'You must be logged in!'
  end

  def already_liked?
    Like.where(user_id: current_user.id, post_id: params[:post_id]).exists? if logged?
  end

end
