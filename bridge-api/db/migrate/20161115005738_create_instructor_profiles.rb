class CreateInstructorProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :instructor_profiles do |t|
      t.integer :user_id
      t.integer :months_playing
      t.string :main_instrument

      t.timestamps
    end
  end
end
