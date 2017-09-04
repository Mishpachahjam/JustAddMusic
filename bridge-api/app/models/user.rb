class User < ApplicationRecord
	has_secure_password
	has_one :facebook_account, dependent: :destroy
	has_many :student_profiles, dependent: :destroy
	has_many :instructor_profiles, dependent: :destroy

	has_one :student_profile, -> { order(created_at: :desc) }, class_name: "StudentProfile"
	has_one :instructor_profile, -> { order(created_at: :desc) }, class_name: "InstructorProfile"

end
