require "test_helper"

class SchoolStaffControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get school_staff_login_url
    assert_response :success
  end

  test "should get home" do
    get school_staff_home_url
    assert_response :success
  end
end
