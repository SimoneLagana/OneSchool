require "test_helper"

class StudentControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get student_home_url
    assert_response :success
  end

  test "should get login" do
    get student_login_url
    assert_response :success
  end
end
