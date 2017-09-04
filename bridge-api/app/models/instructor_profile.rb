class InstructorProfile < ApplicationRecord
	belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
	has_one :facebook_account, :through => :user
	# has_one :user

	def instructor_experience_friendly
		result = INSTRUCTOR_EXPERIENCE[:"#{self.instructor_experience}"]
		result
	end
	def main_instrument_friendly
    	# Rails.logger.info("main_instrument_friendly")
		result = INSTRUMENTS[:"#{self.main_instrument}"]
		result
	end
end
