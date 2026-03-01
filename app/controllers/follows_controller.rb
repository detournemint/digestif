class FollowsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    Current.user.follow(@user)
    redirect_back fallback_location: users_path, notice: "You are now following #{@user.username}."
  end

  def destroy
    @user = User.find(params[:user_id])
    Current.user.unfollow(@user)
    redirect_back fallback_location: users_path, notice: "You unfollowed #{@user.username}."
  end
end
