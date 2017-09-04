class RemoveMonthsPlayingFromInstructorProfile < ActiveRecord::Migration[5.0]
  def change
    remove_column :instructor_profiles, :months_playing, :integer
  end
end
