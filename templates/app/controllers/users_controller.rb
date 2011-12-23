class UsersController < ApplicationController
  expose(:user)
  expose(:users) { User.page(params[:page]) }

  def create
    user.save
    respond_with(user, flash_now: :on_failure)
  end

  def update
    user.save
    respond_with(user, flash_now: :on_failure)
  end

  def destroy
    user.destroy
    respond_with(user)
  end
end
