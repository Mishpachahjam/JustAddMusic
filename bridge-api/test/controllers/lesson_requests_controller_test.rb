require 'test_helper'

class LessonRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lesson_request = lesson_requests(:one)
  end

  test "should get index" do
    get lesson_requests_url, as: :json
    assert_response :success
  end

  test "should create lesson_request" do
    assert_difference('LessonRequest.count') do
      post lesson_requests_url, params: { lesson_request: { instructor_id: @lesson_request.instructor_id, is_open: @lesson_request.is_open, student_id: @lesson_request.student_id } }, as: :json
    end

    assert_response 201
  end

  test "should show lesson_request" do
    get lesson_request_url(@lesson_request), as: :json
    assert_response :success
  end

  test "should update lesson_request" do
    patch lesson_request_url(@lesson_request), params: { lesson_request: { instructor_id: @lesson_request.instructor_id, is_open: @lesson_request.is_open, student_id: @lesson_request.student_id } }, as: :json
    assert_response 200
  end

  test "should destroy lesson_request" do
    assert_difference('LessonRequest.count', -1) do
      delete lesson_request_url(@lesson_request), as: :json
    end

    assert_response 204
  end
end
