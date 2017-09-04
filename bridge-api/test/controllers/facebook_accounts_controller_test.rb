require 'test_helper'

class FacebookAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @facebook_account = facebook_accounts(:one)
  end

  test "should get index" do
    get facebook_accounts_url, as: :json
    assert_response :success
  end

  test "should create facebook_account" do
    assert_difference('FacebookAccount.count') do
      post facebook_accounts_url, params: { facebook_account: { access_token: @facebook_account.access_token, email: @facebook_account.email, facebook_account_id: @facebook_account.facebook_account_id, first_name: @facebook_account.first_name, last_name: @facebook_account.last_name, picture_url: @facebook_account.picture_url, user_id: @facebook_account.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show facebook_account" do
    get facebook_account_url(@facebook_account), as: :json
    assert_response :success
  end

  test "should update facebook_account" do
    patch facebook_account_url(@facebook_account), params: { facebook_account: { access_token: @facebook_account.access_token, email: @facebook_account.email, facebook_account_id: @facebook_account.facebook_account_id, first_name: @facebook_account.first_name, last_name: @facebook_account.last_name, picture_url: @facebook_account.picture_url, user_id: @facebook_account.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy facebook_account" do
    assert_difference('FacebookAccount.count', -1) do
      delete facebook_account_url(@facebook_account), as: :json
    end

    assert_response 204
  end
end
