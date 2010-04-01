class Invoice < ActiveRecord::Base
	def invoice_name
		"#{project}"
	end
	
end


# Example
class Post < ActiveRecord::Base
    belongs_to :author
  end
  class Author < ActiveRecord::Base
    has_many :posts
    def name_with_initial
      "#{first_name.first}. #{last_name}"
    end
  end

  #<%= collection_select(:myinvoice, :project, @invoices, :id, :name) %>