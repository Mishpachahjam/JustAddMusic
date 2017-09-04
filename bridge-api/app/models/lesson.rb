class Lesson < ApplicationRecord
	belongs_to :student, :class_name => 'User', :foreign_key => 'student_id'
	belongs_to :instructor, :class_name => 'User', :foreign_key => 'instructor_id'

	def time_until
		result = (self.starts_at.to_f - DateTime.current.to_f).to_i
		result
	end
end
