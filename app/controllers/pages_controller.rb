class PagesController < ApplicationController
  def main
    @posts = Post.all
  end
end
