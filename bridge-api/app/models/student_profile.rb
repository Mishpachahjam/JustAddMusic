class StudentProfile < ApplicationRecord
	belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
	has_one :facebook_account, :through => :user
	# has_one :user

	def main_instrument_friendly
		result = INSTRUMENTS[:"#{self.main_instrument}"]
		result
	end

	def playing_level_friendly
		result = STUDENT_LEVELS[:"#{self.playing_level}"]
		result
	end
end
