require 'test_helper'

class StudentProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student_profile = student_profiles(:one)
  end

  test "should get index" do
    get student_profiles_url, as: :json
    assert_response :success
  end

  test "should create student_profile" do
    assert_difference('StudentProfile.count') do
      post student_profiles_url, params: { student_profile: { level: @student_profile.level, main_instrument: @student_profile.main_instrument, user_id: @student_profile.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show student_profile" do
    get student_profile_url(@student_profile), as: :json
    assert_response :success
  end

  test "should update student_profile" do
    patch student_profile_url(@student_profile), params: { student_profile: { level: @student_profile.level, main_instrument: @student_profile.main_instrument, user_id: @student_profile.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy student_profile" do
    assert_difference('StudentProfile.count', -1) do
      delete student_profile_url(@student_profile), as: :json
    end

    assert_response 204
  end
end
