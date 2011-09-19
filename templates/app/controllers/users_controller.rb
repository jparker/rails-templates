class UsersController < InheritedResources::Base
  private
  def collection
    @users ||= end_of_association_chain.page(params[:page]).per(params[:per_page])
  end
end
