class Invoice < ActiveRecord::Base
	belongs_to :project
	
	def invoice_name
		"#{project}"
	end
	
	def total_cost
		sum = 0
		self.project.tasks.each do |task|
		  sum = sum + task.get_cost
		end
		return sum
	end 
	
end
