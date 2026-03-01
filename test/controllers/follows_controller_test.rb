require "test_helper"

class FollowsControllerTest < ActionDispatch::IntegrationTest
  test "follow redirects unauthenticated users" do
    post user_follow_path(users(:two))
    assert_redirected_to new_session_path
  end

  test "unfollow redirects unauthenticated users" do
    delete user_follow_path(users(:two))
    assert_redirected_to new_session_path
  end

  test "authenticated user can follow another user" do
    sign_in_as(users(:two))
    assert_difference "Follow.count", 1 do
      post user_follow_path(users(:one))
    end
  end

  test "authenticated user can unfollow" do
    sign_in_as(users(:one))
    # users(:one) already follows users(:two) via fixture
    assert_difference "Follow.count", -1 do
      delete user_follow_path(users(:two))
    end
  end
end
