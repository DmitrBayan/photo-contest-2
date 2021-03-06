# frozen_string_literal: true

class SessionController < ApplicationController
  def create
    outcome = ::Users::Auth.run(auth_hash: request.env['omniauth.auth'].to_h)
    if outcome.valid?
      @user = outcome.result
      session[:user_id] = @user.id
      flash[:success] = 'Welcome!'
    else
      flash[:warning] = outcome.errors.full_messages
    end
    redirect_to root_path
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_path
  end
end
