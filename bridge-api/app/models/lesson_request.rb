class LessonRequest < ApplicationRecord
	belongs_to :student, :class_name => 'User', :foreign_key => 'student_id'
	belongs_to :instructor, :class_name => 'User', :foreign_key => 'instructor_id'

	# has_one :student_profile, :through => :student
	# has_one :instructor_profile, :through => :instructor
end
