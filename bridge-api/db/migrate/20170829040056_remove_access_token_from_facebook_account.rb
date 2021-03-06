class RemoveAccessTokenFromFacebookAccount < ActiveRecord::Migration[5.0]

  def up
      change_column :facebook_accounts, :access_token, :text
  end
  def down
      # This might cause trouble if you have strings longer
      # than 255 characters.
      change_column :facebook_accounts, :access_token, :string
  end

end
