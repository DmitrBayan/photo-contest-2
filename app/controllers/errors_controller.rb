# frozen_string_literal: true

class ErrorsController < ApplicationController
  def error_404
    render status: :not_found, layout: false
  end

  def error_500
    render status: :internal_server_error, layout: false
  end
end
