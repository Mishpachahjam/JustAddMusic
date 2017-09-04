class CreateFacebookAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_accounts do |t|
      t.integer :user_id
      t.string :facebook_account_id
      t.string :access_token
      t.string :picture_url
      t.string :email
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
