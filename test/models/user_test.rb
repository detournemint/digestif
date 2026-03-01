require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal "downcased@example.com", user.email_address
  end

  test "email must be unique" do
    duplicate = User.new(email_address: users(:one).email_address, username: "unique", password: "password123456")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email_address], "has already been taken"
  end

  test "username must be unique case insensitively" do
    duplicate = User.new(email_address: "new@example.com", username: "USERONE", password: "password123456")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:username], "has already been taken"
  end

  test "username only allows letters, numbers, and underscores" do
    user = User.new(email_address: "test@example.com", username: "bad username!", password: "password123456")
    assert_not user.valid?
    assert_includes user.errors[:username], "only allows letters, numbers, and underscores"
  end

  test "password must be at least 12 characters" do
    user = User.new(email_address: "test@example.com", username: "testuser", password: "short")
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "password with 12 or more characters is valid" do
    user = User.new(
      email_address: "test@example.com",
      username: "testuser",
      password: "a" * 12,
      password_confirmation: "a" * 12
    )
    assert user.valid?
  end
end
