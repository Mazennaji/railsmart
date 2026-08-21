require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    assert users(:buyer).valid?
  end

  test "requires an email" do
    user = users(:buyer)
    user.email = nil
    assert_not user.valid?
  end

  test "email must be unique" do
    dupe = User.new(email: "buyer@example.com", password: "password123")
    assert_not dupe.valid?
  end

  test "authenticates with correct password" do
    assert users(:buyer).authenticate("password123")
  end

  test "rejects wrong password" do
    assert_not users(:buyer).authenticate("wrong")
  end

  test "admin flag" do
    assert users(:boss).admin?
    assert_not users(:buyer).admin?
  end
end