class Invoice < ActiveRecord::Base
	def invoice_name
		"#{project}"
	end
	
end
