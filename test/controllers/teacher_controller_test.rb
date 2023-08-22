require "test_helper"

class TeacherControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get teacher_login_url
    assert_response :success
  end

  test "should get home" do
    get teacher_home_url
    assert_response :success
  end

  test "should get meeting" do
    get teacher_meeting_url
    assert_response :success
  end
end
