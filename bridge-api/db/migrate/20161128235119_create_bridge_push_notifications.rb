class CreateBridgePushNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :bridge_push_notifications do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :message

      t.timestamps
    end
  end
end
