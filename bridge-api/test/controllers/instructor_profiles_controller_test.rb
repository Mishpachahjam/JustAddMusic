require 'test_helper'

class InstructorProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @instructor_profile = instructor_profiles(:one)
  end

  test "should get index" do
    get instructor_profiles_url, as: :json
    assert_response :success
  end

  test "should create instructor_profile" do
    assert_difference('InstructorProfile.count') do
      post instructor_profiles_url, params: { instructor_profile: { main_instrument: @instructor_profile.main_instrument, months_playing: @instructor_profile.months_playing, user_id: @instructor_profile.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show instructor_profile" do
    get instructor_profile_url(@instructor_profile), as: :json
    assert_response :success
  end

  test "should update instructor_profile" do
    patch instructor_profile_url(@instructor_profile), params: { instructor_profile: { main_instrument: @instructor_profile.main_instrument, months_playing: @instructor_profile.months_playing, user_id: @instructor_profile.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy instructor_profile" do
    assert_difference('InstructorProfile.count', -1) do
      delete instructor_profile_url(@instructor_profile), as: :json
    end

    assert_response 204
  end
end
