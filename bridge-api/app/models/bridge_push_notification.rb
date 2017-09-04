require 'houston'

class BridgePushNotification < ApplicationRecord
	def send_to_user(user, app_mode, is_silent, type, custom_data)
		Rails.logger.info("send_to_player".colorize(:color => :white, :background => :blue))

    Rails.logger.info("user: #{user.id} app_mode: #{app_mode}")
    Rails.logger.info("push_token: #{user.push_token}")

    begin
      if app_mode == DEVELOPMENT_MODE
        Rails.logger.info("DEVELOPMENT_MODE")
        # passphrase = ENV["APN_KEY_PWD"]
        # passphrase = nil

        apn = Houston::Client.development
        apn.certificate = File.read("certs/apple_push_notification_dev.pem")
      elsif app_mode == PRODUCTION_MODE
        Rails.logger.info("PRODUCTION_MODE")
        # passphrase = ENV["APN_KEY_PWD"]
        # passphrase = nil

        apn = Houston::Client.production
        apn.certificate = File.read("certs/apple_push_notification_prod.pem")
      end

      content = self.message

      stripped_string = ActionView::Base.full_sanitizer.sanitize(content)

      token = "81feb46a8b4fd7f4970e760e47efa56fc7d8e686cad1ee4d6d50fbf721bea04a"
      token = user.push_token

      if !is_silent
        notification = Houston::Notification.new(device: token)

        notification.sound = "sosumi.aiff"
        notification.alert = stripped_string
        notification.badge = 1
        
        case type
        when BRIDGE_NOTIFICATION_TEST
          notification.custom_data = { 
            user_id: user.id,
            notification_type: type
          }
        when BRIDGE_NOTIFICATION_NEW_MESSAGE
          notification.custom_data = { 
            user_id: user.id,
            notification_type: type
          }
        when BRIDGE_NOTIFICATION_NEW_LESSON_REQUEST
          notification.custom_data = { 
            user_id: user.id,
            notification_type: type
          }
        when BRIDGE_NOTIFICATION_LESSON_REQUEST_DENIED
          notification.custom_data = { 
            user_id: user.id,
            notification_type: type
          }
        when BRIDGE_NOTIFICATION_NEW_LESSON
          notification.custom_data = { 
            user_id: user.id,
            notification_type: type
          }
        end

        Rails.logger.info("Error: #{notification.error}.") if notification.error
      else
        notification = Houston::Notification.new(sound: '', device: token)

        notification.badge = 1

        case type
        when BRIDGE_NOTIFICATION_TEST
          notification.custom_data = { 
            user_id: user.id,
            notification_type: type
          }
        when BRIDGE_NOTIFICATION_NEW_MESSAGE
          notification.custom_data = { 
            user_id: user.id,
            notification_type: type
          }
        when BRIDGE_NOTIFICATION_NEW_LESSON_REQUEST
          notification.custom_data = { 
            user_id: user.id,
            notification_type: type
          }
        when BRIDGE_NOTIFICATION_LESSON_REQUEST_DENIED
          notification.custom_data = { 
            user_id: user.id,
            notification_type: type
          }
        when BRIDGE_NOTIFICATION_NEW_LESSON
          notification.custom_data = { 
            user_id: user.id,
            notification_type: type
          }
        end
        
        Rails.logger.info("Error: #{notification.error}.") if notification.error
      end

      apn.push(notification)

      Rails.logger.info("#{content}".colorize(:color => :black, :background => :green))
      Rails.logger.info("Sent Push to Token: " + token.to_s)

      return nil
    rescue Exception => e
      Rails.logger.info("#{e.message}".colorize(:color => :black, :background => :red))
      return e.message
    end
  end
end

