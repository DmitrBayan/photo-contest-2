# frozen_string_literal: true
module Api
  class ApiController < ActionController::API
    before_action :verify_authenticity_token, only: [:create, :destroy, :update]

    rescue_from ::Errors::Base, with: :render_error

    def validate_result outcome
      if outcome.valid?
        render json: outcome.result, status: :created
      else
        render json: outcome.errors, status: :unprocessable_entity
      end
    end

    def current_user
      User.find_by(authenticity_token: token)
    end

    def validate_user user
      raise ::Errors::NotAllowed unless current_user.id == user.id
    end

    def verify_authenticity_token
      token = request.headers['X-Token']
      raise ::Errors::Unauthenticated unless token

      raise ::Errors::InvalidCredentials unless current_user
    end

    private

    def render_error(exception)
      render json: {message: exception.message}, status: exception.status
    end
  end
end
