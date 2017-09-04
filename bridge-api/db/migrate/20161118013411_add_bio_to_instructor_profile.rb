class AddBioToInstructorProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :instructor_profiles, :bio, :string
  end
end
