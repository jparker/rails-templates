class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:username], params[:password], params[:remember_me])
    if user
      redirect_back_or_to root_url, notice: 'You are now signed in.'
    else
      flash.now.alert = 'The username or password you entered was invalid.'
      render :new
    end
  end

  def destroy
    logout
    redirect_to sign_in_url, notice: 'You are now signed out.'
  end
end
