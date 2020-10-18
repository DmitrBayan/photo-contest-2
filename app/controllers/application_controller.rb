# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper

  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from AbstractController::ActionNotFound, with: :render_404
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  protect_from_forgery with: :exception

  helper_method :current_user, :current_country

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_country
    @current_country ||= Geocoder.search(request.remote_ip).first.country
  end

  def authenticate_admin_user!
    render_404 if current_user.blank? || !current_user.admin?
  end

  def render_404
    respond_to do |format|
      format.html { render 'errors/error_404', status: :not_found }
      format.json { render json: { message: 'not found' }, status: :not_found }
    end
  end
end
