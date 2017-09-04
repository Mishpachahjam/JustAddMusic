class BridgePushNotificationsController < ApplicationController
  before_action :set_bridge_push_notification, only: [:show, :update, :destroy]

  # GET /bridge_push_notifications
  def index
    @bridge_push_notifications = BridgePushNotification.all

    render json: @bridge_push_notifications
  end

  # GET /bridge_push_notifications/1
  def show
    render json: @bridge_push_notification
  end

  # POST /bridge_push_notifications
  def create
    @bridge_push_notification = BridgePushNotification.new(bridge_push_notification_params)

    if @bridge_push_notification.save
      render json: @bridge_push_notification, status: :created, location: @bridge_push_notification
    else
      render json: @bridge_push_notification.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bridge_push_notifications/1
  def update
    if @bridge_push_notification.update(bridge_push_notification_params)
      render json: @bridge_push_notification
    else
      render json: @bridge_push_notification.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bridge_push_notifications/1
  def destroy
    @bridge_push_notification.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bridge_push_notification
      @bridge_push_notification = BridgePushNotification.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bridge_push_notification_params
      params.require(:bridge_push_notification).permit(:sender_id, :receiver_id, :message)
    end
end
