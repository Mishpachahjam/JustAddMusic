class AddInstructorExperienceToInstructorProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :instructor_profiles, :instructor_experience, :string
  end
end
