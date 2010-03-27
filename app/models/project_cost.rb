class ProjectCost < ActiveRecord::Base
	
	# Abstract method to be implemented in subclasses Expense
	# and HourReport
	def get_cost
	end
end
