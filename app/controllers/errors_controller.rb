# frozen_string_literal: true

class ErrorsController < ApplicationController
  def error_404
    render layout: false
  end
end
