require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  # --- Authentication ---

  test "new redirects unauthenticated users" do
    get new_post_path
    assert_redirected_to new_session_path
  end

  test "create redirects unauthenticated users" do
    post posts_path, params: { post: { body: "Hello" } }
    assert_redirected_to new_session_path
  end

  test "edit redirects unauthenticated users" do
    get edit_post_path(posts(:one))
    assert_redirected_to new_session_path
  end

  test "update redirects unauthenticated users" do
    patch post_path(posts(:one)), params: { post: { body: "Updated" } }
    assert_redirected_to new_session_path
  end

  # --- Authorization (IDOR) ---

  test "cannot edit another user's post" do
    sign_in_as(users(:one))
    # posts(:two) belongs to users(:two) — should 404, not leak the post
    get edit_post_path(posts(:two))
    assert_response :not_found
  end

  test "cannot update another user's post" do
    sign_in_as(users(:one))
    patch post_path(posts(:two)), params: { post: { body: "Hijacked" } }
    assert_response :not_found
    assert_not_equal "Hijacked", posts(:two).reload.body
  end

  # --- Business rules ---

  test "cannot edit a post from a previous day" do
    sign_in_as(users(:one))
    # posts(:one) has published_at in the past (fixture date is 2026-02-24)
    get edit_post_path(posts(:one))
    assert_redirected_to root_path
  end

  test "new redirects to edit when user has already posted today" do
    sign_in_as(users(:one))
    todays_post = users(:one).posts.create!(body: "Today's post")
    get new_post_path
    assert_redirected_to edit_post_path(todays_post)
  end

  test "can attach an image to a post" do
    sign_in_as(users(:one))
    image = fixture_file_upload("avatar.png", "image/png")
    post posts_path, params: { post: { body: "A post with a photo.", image: image } }
    assert_redirected_to root_path
    assert Post.last.image.attached?
  end

  test "create a valid post" do
    sign_in_as(users(:one))
    assert_difference "Post.count", 1 do
      post posts_path, params: { post: { body: "A brand new thought." } }
    end
    assert_redirected_to root_path
  end

  test "create with invalid params re-renders new" do
    sign_in_as(users(:one))
    post posts_path, params: { post: { body: "" } }
    assert_response :unprocessable_entity
  end
end
