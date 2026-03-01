require "test_helper"

class DigestsControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated users to login" do
    get root_path
    assert_redirected_to new_session_path
  end

  test "authenticated user sees the digest" do
    sign_in_as(users(:one))
    get root_path
    assert_response :success
  end
end
