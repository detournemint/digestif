class DigestsController < ApplicationController
  def show
    followed_ids = Current.user.following.pluck(:id)
    @posts = Post.where(user_id: followed_ids).from_yesterday.recent.includes(:user)
    @todays_post = Current.user.todays_post
  end
end
