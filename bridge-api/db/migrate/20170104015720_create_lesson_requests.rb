class CreateLessonRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :lesson_requests do |t|
      t.boolean :is_open
      t.integer :student_id
      t.integer :instructor_id

      t.timestamps
    end
  end
end
