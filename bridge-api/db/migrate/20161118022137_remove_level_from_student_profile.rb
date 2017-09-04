class RemoveLevelFromStudentProfile < ActiveRecord::Migration[5.0]
  def change
    remove_column :student_profiles, :level, :string
  end
end
