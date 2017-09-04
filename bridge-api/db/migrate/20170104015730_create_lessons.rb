class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.integer :student_id
      t.integer :instructor_id
      t.datetime :starts_at

      t.timestamps
    end
  end
end
