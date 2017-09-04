class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      render json: command.result, status: :success
    else
      render json: { 
      	error: command.errors 
      }, status: :unauthorized
    end
  end

  def authenticate_with_facebook
    # @facebook_account = FacebookAccount.new(
    #   :user_id => @user.id,
    #   :access_token => params[:facebook_access_token],
    #   :facebook_account_id => params[:facebook_data][:id],
    #   :email => params[:facebook_data][:email],
    #   :first_name => params[:facebook_data][:first_name],
    #   :last_name => params[:facebook_data][:last_name],
    #   :picture_url => params[:facebook_data][:picture][:data][:url]
    # )

    command = AuthenticateUserWithFacebook.call(params[:facebook_data][:email], params[:facebook_data][:id])

    if command.success?
      render json: command.result, status: :success
    else
      render json: { 
        error: command.errors 
      }, status: :unauthorized
    end
  end
end