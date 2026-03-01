class PostsController < ApplicationController
  before_action :set_post, only: %i[ edit update ]
  before_action :ensure_editable, only: %i[ edit update ]

  def new
    if Current.user.posted_today?
      redirect_to edit_post_path(Current.user.todays_post)
    else
      @post = Current.user.posts.build
    end
  end

  def create
    @post = Current.user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "Posted! It will appear in your followers' digest tomorrow."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to root_path, notice: "Post updated. It will appear in your followers' digest tomorrow."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Current.user.posts.find(params[:id])
  end

  def ensure_editable
    unless @post.published_at&.today?
      redirect_to root_path, alert: "You can only edit today's post."
    end
  end

  def post_params
    params.require(:post).permit(:body)
  end
end
