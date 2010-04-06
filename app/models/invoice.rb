class Invoice < ActiveRecord::Base
	belongs_to :project
	
	def invoice_name
		"#{project}"
	end
	
end
