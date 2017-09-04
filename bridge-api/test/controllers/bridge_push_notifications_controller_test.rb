require 'test_helper'

class BridgePushNotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bridge_push_notification = bridge_push_notifications(:one)
  end

  test "should get index" do
    get bridge_push_notifications_url, as: :json
    assert_response :success
  end

  test "should create bridge_push_notification" do
    assert_difference('BridgePushNotification.count') do
      post bridge_push_notifications_url, params: { bridge_push_notification: { message: @bridge_push_notification.message, receiver_id: @bridge_push_notification.receiver_id, sender_id: @bridge_push_notification.sender_id } }, as: :json
    end

    assert_response 201
  end

  test "should show bridge_push_notification" do
    get bridge_push_notification_url(@bridge_push_notification), as: :json
    assert_response :success
  end

  test "should update bridge_push_notification" do
    patch bridge_push_notification_url(@bridge_push_notification), params: { bridge_push_notification: { message: @bridge_push_notification.message, receiver_id: @bridge_push_notification.receiver_id, sender_id: @bridge_push_notification.sender_id } }, as: :json
    assert_response 200
  end

  test "should destroy bridge_push_notification" do
    assert_difference('BridgePushNotification.count', -1) do
      delete bridge_push_notification_url(@bridge_push_notification), as: :json
    end

    assert_response 204
  end
end
