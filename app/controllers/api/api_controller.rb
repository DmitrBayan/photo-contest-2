# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    include MetaData

    before_action :verify_authenticity_token, only: %i[create destroy update]

    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from AbstractController::ActionNotFound, with: :render_404
    rescue_from ::Errors::Base, with: :render_error

    def validate_result(outcome)
      if outcome.valid?
        render json: outcome.result, status: :created
      else
        render json: outcome.errors, status: :unprocessable_entity
      end
    end

    def current_user
      @current_user ||= User.find_by(authenticity_token: token)
    end

    def validate_user(user)
      raise ::Errors::NotAllowed unless current_user.id == user.id
    end

    def verify_authenticity_token
      raise ::Errors::Unauthenticated unless token

      raise ::Errors::InvalidCredentials unless current_user
    end

    def token
      @token ||= request.headers['X-Token']
    end

    def render_404
      raise ::Errors::NotFound
    end

    private

    def render_error(exception)
      render json: { message: exception.message }, status: exception.status
    end
  end
end
