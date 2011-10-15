class UsersController < InheritedResources::Base
  expose(:user)
  expose(:users) { User.page(params[:page]) }
end
