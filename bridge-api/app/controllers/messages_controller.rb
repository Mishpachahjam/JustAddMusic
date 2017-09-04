class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update, :destroy]

  # GET /messages
  # def index
  #   @messages = Message.all

  #   render json: @messages
  # end

  #
  def new_message
    Rails.logger.info('new_message')

    begin
      sender = nil

      if (params[:sender_id])
        sender = User.find_by_id(params[:sender_id])
        receiver = User.find_by_id(params[:receiver_id])

        if (!sender.nil?)
          message = nil

          Rails.logger.info("receiver_id: #{params[:receiver_id]}")
          Rails.logger.info("sender_id: #{params[:sender_id]}")

          message = Message.new(:status => "unread", :receiver_id => params[:receiver_id], :sender_id => params[:sender_id], :subject => params[:subject], :body => params[:body])
          message.save

          Rails.logger.info("notification start")

          Rails.logger.info("#{sender.username}")

          notification = SwitcharooNotification.new(:content => "#{sender.username} just sent you a message.", :notification_type => NOTIFICATIONTYPE_MESSAGE_RECEIVED, :user_id => params[:receiver_id])

          notification.save

          notification.send_to_user(receiver)

          Rails.logger.info("notification end")

          render json: { error_code: ERROR_NOERROR, status: "ok", message: message, sender: sender }
          return
        else
          render json: {error_code: ERROR_NOTFOUND, status: "Can't find sender."}
          return
        end
      else
          render json: {error_code: ERROR_MISSINGARGUMENTS, status: "Missing arguments"}
      end

      render json: {
        error_code: ERROR_FAILED, 
        status: "Unknown"
      }

    rescue StandardError => e
      Log.logError("new_message failed: #{e.to_s}")
      Rails.logger.error e.backtrace.join("\n") unless Rails.env.production?
      render json: {error_code: ERROR_FAILED, status: e.to_s }
    end
  end

  def index
    Rails.logger.info("get_messages".colorize(:color => :white, :background => :blue))

    Rails.logger.info("receiver_id: #{params[:receiver_id]}")
    Rails.logger.info("user_id: #{params[:user_id]}")

    messages = []

    outgoing_messages = Message.where('receiver_id = ? AND sender_id = ?', params[:receiver_id], params[:user_id]).pluck(:created_at, :message)

    outgoing_messages.each do |message|
      message.push('out')
    end

    Rails.logger.info("outgoing_messages: #{outgoing_messages}")

    incoming_messages = Message.where('receiver_id = ? AND sender_id = ?', params[:user_id], params[:receiver_id]).pluck(:created_at, :message)
    
    incoming_messages.each do |message|
      message.push('in')
    end

    Rails.logger.info("incoming_messages: #{incoming_messages}")

    messages = incoming_messages + outgoing_messages

    Rails.logger.info("messages: #{messages}")

    sorted_messages = messages.sort {|a,b| a[0] <=> b[0]}.reverse

    Rails.logger.info("sorted_messages: #{sorted_messages}")

    render json: {
      messages: sorted_messages 
    }
    return
  end

  def get_messages
    Rails.logger.info("get_messages".colorize(:color => :white, :background => :blue))

    Rails.logger.info("sender_id: #{params[:sender_id]}")
    Rails.logger.info("user_id: #{params[:user_id]}")

    messages = []

    outgoing_messages = Message.where('receiver_id = ? AND sender_id = ?', params[:sender_id], params[:user_id]).pluck(:created_at, :message)

    outgoing_messages.each do |message|
      message.push('out')
    end

    Rails.logger.info("outgoing_messages: #{outgoing_messages}")

    incoming_messages = Message.where('receiver_id = ? AND sender_id = ?', params[:user_id], params[:sender_id]).pluck(:created_at, :message)
    
    incoming_messages.each do |message|
      message.push('in')
    end

    Rails.logger.info("incoming_messages: #{incoming_messages}")

    messages = incoming_messages + outgoing_messages

    Rails.logger.info("messages: #{messages}")

    sorted_messages = messages.sort {|a,b| a[0] <=> b[0]}.reverse

    Rails.logger.info("sorted_messages: #{sorted_messages}")

    render json: {
      messages: sorted_messages 
    }
    return
  end

  def get_message_roster
    Rails.logger.info("get_message_roster".colorize(:color => :black, :background => :yellow))

    Rails.logger.info("user_id: #{params[:user_id]}")

    users = []

    begin
      sender_ids = Message.where(:receiver_id => params[:user_id]).order(created_at: :desc).uniq.pluck(:sender_id, :created_at)
      Rails.logger.info("sender_ids: #{sender_ids.to_s}")

      receiver_ids = Message.where(:sender_id => params[:user_id]).order(created_at: :desc).uniq.pluck(:receiver_id, :created_at)
      Rails.logger.info("receiver_ids: #{receiver_ids.to_s}")

      user_ids = sender_ids + receiver_ids
      Rails.logger.info("user_ids: #{user_ids.to_s}")

      sorted_user_ids = user_ids.sort {|a,b| a[1] <=> b[1]}.reverse
      Rails.logger.info("sorted_user_ids: #{sorted_user_ids.to_s}")

      unique_user_ids = sorted_user_ids.uniq(&:first)
      Rails.logger.info("unique_user_ids: #{unique_user_ids.to_s}")

      user_ids = unique_user_ids.map(&:first)
      Rails.logger.info("user_ids: #{user_ids.to_s}")

      # users = User.where(id: user_ids).select(:id, :username)
      # users = User.find(user_ids, :order => "field(id, #{ids.join(',')})") 

      # preserve array order without this command returned records will be ordered [1...n]

      if !user_ids.empty?
        # users = User.includes(:facebook_account).where(id: user_ids).select(:id).order("field(id, #{user_ids.join ','})")
        users = User.joins(:facebook_account).where(id: user_ids).select("users.id, facebook_accounts.first_name, facebook_accounts.last_name").order("field(users.id, #{user_ids.join ','})")
      end

    rescue StandardError => e
        Rails.logger.error e unless Rails.env.production?
    end

    render json: { 
      users: users 
    }
    return
  end
  #

  # GET /messages/1
  def show
    render json: @message
  end

  # POST /messages
  def create
    @message = Message.new(message_params)

    if @message.save
      Rails.logger.info("notification start")
      custom_data = {
        :data => nil
      }

      notification = BridgePushNotification.new(
        :receiver_id => @message.receiver.id,
        :message => "You've got a message!"
      )

      notification.save
      notification.send_to_user(@message.receiver, DEVELOPMENT_MODE, false, BRIDGE_NOTIFICATION_NEW_MESSAGE, custom_data)
      Rails.logger.info("notification end")

      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:sender_id, :receiver_id, :message, :is_new)
    end
end
