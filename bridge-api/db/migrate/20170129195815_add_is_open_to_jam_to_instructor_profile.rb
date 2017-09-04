class AddIsOpenToJamToInstructorProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :instructor_profiles, :is_open_to_jam, :boolean
  end
end
