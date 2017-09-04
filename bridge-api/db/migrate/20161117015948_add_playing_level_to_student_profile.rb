class AddPlayingLevelToStudentProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :student_profiles, :playing_level, :string
  end
end
