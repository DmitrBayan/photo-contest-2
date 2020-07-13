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
    return if logged?

    flash[:warning] = 'You must be logged in!'
    redirect_to root_path
  end
end
