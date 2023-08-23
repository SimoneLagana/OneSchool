require "test_helper"

class FamilyControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get family_home_url
    assert_response :success
  end

  test "should get login" do
    get family_login_url
    assert_response :success
  end
end
