# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from AbstractController::ActionNotFound, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_admin_user!
    render_404 unless current_user.admin? 
  end

  def render_404
    respond_to do |format|
      format.html { render template: 'errors/error_404', status: :not_found }
      format.all { render nothing: true, status: :not_found }
    end
  end
end
