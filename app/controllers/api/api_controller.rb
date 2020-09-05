# frozen_string_literal: true

module Api
  class ApiController < ApplicationController
    before_action :verify_authenticity_token, only: [:create, :destroy, :update]

    rescue_from ::Errors::Base, with: :render_error

    def validate_result outcome
      if outcome.valid?
        render json: outcome.result, status: :ok
      else
        render json: outcome.errors, status: :unprocessable_entity
      end
    end

    def validate_user user
      raise ::Errors::NotAllowed unless @api_user.id == user.id
    end

    def verify_authenticity_token
      token = request.headers['token']
      @api_user = User.find_by(authenticity_token: token)
      raise ::Errors::InvalidCredentials unless @api_user
    end

    private

    def render_error(exception)
      render json: {message: exception.default_message}, status: exception.default_status
    end
  end
end