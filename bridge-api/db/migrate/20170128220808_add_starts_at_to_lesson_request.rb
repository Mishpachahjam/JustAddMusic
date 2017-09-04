class AddStartsAtToLessonRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :lesson_requests, :starts_at, :datetime
  end
end
