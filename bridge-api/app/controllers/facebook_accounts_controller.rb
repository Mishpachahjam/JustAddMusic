class FacebookAccountsController < ApplicationController
  before_action :set_facebook_account, only: [:show, :update, :destroy]

  # GET /facebook_accounts
  def index
    @facebook_accounts = FacebookAccount.all

    render json: @facebook_accounts
  end

  # GET /facebook_accounts/1
  def show
    render json: @facebook_account
  end

  # POST /facebook_accounts
  def create
    @facebook_account = FacebookAccount.new(facebook_account_params)

    if @facebook_account.save
      render json: @facebook_account, status: :created, location: @facebook_account
    else
      render json: @facebook_account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /facebook_accounts/1
  def update
    if @facebook_account.update(facebook_account_params)
      render json: @facebook_account
    else
      render json: @facebook_account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /facebook_accounts/1
  def destroy
    @facebook_account.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facebook_account
      @facebook_account = FacebookAccount.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def facebook_account_params
      params.require(:facebook_account).permit(:user_id, :facebook_account_id, :access_token, :picture_url, :email, :first_name, :last_name)
    end
end
