# frozen_string_literal: true

module Api
  class ApiController < ApplicationController
    def validate(outcome)
      if outcome.valid?
        render json: { message: 'Created' }, status: :ok
      else
        render json: outcome.errors, status: :unprocessable_entity
      end
    end

    def verify_authenticate_token
      token = request.headers['token']
      @api_user = User.find_by(authenticate_token: token)
      raise ::Errors::InvalidCredentials unless @api_user
    end

  end
end