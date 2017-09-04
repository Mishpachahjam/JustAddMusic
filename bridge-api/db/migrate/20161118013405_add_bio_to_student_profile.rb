class AddBioToStudentProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :student_profiles, :bio, :string
  end
end
