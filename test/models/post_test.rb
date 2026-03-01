require "test_helper"

class PostTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test "body is required" do
    post = @user.posts.build(body: "")
    assert_not post.valid?
    assert_includes post.errors[:body], "can't be blank"
  end

  test "body cannot exceed 500 characters" do
    post = @user.posts.build(body: "a" * 501)
    assert_not post.valid?
    assert post.errors[:body].any?
  end

  test "body at exactly 500 characters is valid" do
    post = @user.posts.build(body: "a" * 500)
    assert post.valid?
  end

  test "published_at is set automatically on create" do
    post = @user.posts.create!(body: "Hello world")
    assert_not_nil post.published_at
  end

  test "only one post per day is allowed" do
    @user.posts.create!(body: "First post today")
    second = @user.posts.build(body: "Second post today")
    assert_not second.valid?
    assert_includes second.errors[:base], "You can only post once per day. Come back tomorrow!"
  end

  test "different users can each post once per day" do
    @user.posts.create!(body: "User one's post")
    other_user = users(:two)
    other_post = other_user.posts.build(body: "User two's post")
    assert other_post.valid?
  end
end
