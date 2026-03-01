require "test_helper"

class FollowTest < ActiveSupport::TestCase
  test "cannot follow yourself" do
    follow = Follow.new(follower: users(:one), followed: users(:one))
    assert_not follow.valid?
    assert_includes follow.errors[:base], "You cannot follow yourself"
  end

  test "cannot follow the same user twice" do
    # users(:one) already follows users(:two) via fixture
    duplicate = Follow.new(follower: users(:one), followed: users(:two))
    assert_not duplicate.valid?
    assert follow_errors_include?(duplicate, "has already been taken")
  end

  test "valid follow between two different users" do
    follow = Follow.new(follower: users(:two), followed: users(:one))
    assert follow.valid?
  end

  private

  def follow_errors_include?(follow, message)
    follow.errors.full_messages.any? { |m| m.include?(message) }
  end
end
