class HourReport < ProjectCost
	validates_presence_of :hours

	def get_cost
		0
	end
end
