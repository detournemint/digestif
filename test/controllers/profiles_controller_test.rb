require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "edit redirects unauthenticated users" do
    get edit_profile_path
    assert_redirected_to new_session_path
  end

  test "update redirects unauthenticated users" do
    patch profile_path, params: { user: { display_name: "Hacker" } }
    assert_redirected_to new_session_path
  end

  test "authenticated user can update their profile" do
    sign_in_as(users(:one))
    patch profile_path, params: { user: { display_name: "New Name", bio: "About me" } }
    assert_redirected_to user_path(users(:one))
    assert_equal "New Name", users(:one).reload.display_name
  end

  test "profile update cannot change email or password" do
    sign_in_as(users(:one))
    original_digest = users(:one).password_digest
    patch profile_path, params: { user: { email_address: "hacked@evil.com", password: "newpassword123456" } }
    users(:one).reload
    assert_equal "one@example.com", users(:one).email_address
    assert_equal original_digest, users(:one).password_digest
  end
end
