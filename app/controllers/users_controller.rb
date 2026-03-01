class UsersController < ApplicationController
  def index
    @users = User.where.not(id: Current.user.id).order(:username)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(published_at: ...Date.current.beginning_of_day).recent.limit(10)
    @followers = @user.followers
    @following = @user.following
  end
end
