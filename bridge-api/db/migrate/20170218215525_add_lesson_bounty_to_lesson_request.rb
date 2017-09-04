class AddLessonBountyToLessonRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :lesson_requests, :is_denied, :boolean, default: false
    add_column :lesson_requests, :is_approved, :boolean, default: false
  end
end
