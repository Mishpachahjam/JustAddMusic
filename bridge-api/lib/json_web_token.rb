# lib/json_web_token.rb

class JsonWebToken
  class << self
    # WITH EXPIRATION
    # def encode(payload, exp = 24.hours.from_now)
    #   payload[:exp] = exp.to_i
    #   JWT.encode(payload, Rails.application.secrets.secret_key_base)
    # end

    def encode(payload)
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end