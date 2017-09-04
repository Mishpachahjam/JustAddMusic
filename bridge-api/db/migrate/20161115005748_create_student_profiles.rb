class CreateStudentProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :student_profiles do |t|
      t.integer :user_id
      t.string :level
      t.string :main_instrument

      t.timestamps
    end
  end
end
