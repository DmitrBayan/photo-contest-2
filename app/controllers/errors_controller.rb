class ErrorsController < ApplicationController
  def error_404
    render status: 404, layout: false
  end

  def error_500
    render status: 500, layout: false
  end
end
