require "test_helper"

class SecurityTest < ActionDispatch::IntegrationTest
  # --- Open redirect ---

  test "redirect after login stores only the path, not full URL with host" do
    get edit_profile_path  # triggers request_authentication, not logged in
    assert_redirected_to new_session_path
    assert session[:return_to_after_authenticating].start_with?("/"),
      "Expected stored return URL to be a path, not a full URL (open redirect risk)"
  end

  test "redirects to original page after login" do
    get edit_profile_path
    post session_path, params: { email_address: users(:one).email_address, password: "password" }
    assert_redirected_to edit_profile_path
  end

  # --- Content Security Policy ---

  test "authenticated response includes Content-Security-Policy header" do
    sign_in_as(users(:one))
    get root_path
    assert response.headers["Content-Security-Policy"].present?,
      "Expected Content-Security-Policy header to be present"
  end

  # --- Sessions ---

  test "all sessions are destroyed after password reset" do
    user = users(:one)
    user.sessions.create!
    assert user.sessions.count >= 1

    put password_path(user.password_reset_token),
      params: { password: "newpassword123456", password_confirmation: "newpassword123456" }

    assert_equal 0, user.reload.sessions.count
  end

  test "login with invalid credentials does not set a session cookie" do
    post session_path, params: { email_address: users(:one).email_address, password: "wrongpassword" }
    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "password reset for unknown email does not leak user existence" do
    post passwords_path, params: { email_address: "nobody@example.com" }
    assert_redirected_to new_session_path
    assert_match "if user with that email address exists", flash[:notice]
  end
end
