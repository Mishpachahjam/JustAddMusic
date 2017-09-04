class AuthenticateUserWithFacebook
  prepend SimpleCommand

  def initialize(email, facebook_account_id)
    @email = email
    @facebook_account_id = facebook_account_id
  end

  def call
    if user
      result = {
        auth_token: JsonWebToken.encode(user_id: user.id),
        user: user.as_json(
          :include => {
            :facebook_account => {},
            :student_profile => {
              :methods => [
                :main_instrument_friendly,
                :playing_level_friendly
              ]
            },
            :instructor_profile => {
              :methods => [
                :instructor_experience_friendly,
                :main_instrument_friendly
              ]
            }
          }
        )
      }
      result
    end
  end

  private

  attr_accessor :email, :facebook_account_id

  def user
    user = User.find_by_email(email)
    # return user if user && user.authenticate(password)
    return user if user && user.facebook_account.facebook_account_id == facebook_account_id

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end