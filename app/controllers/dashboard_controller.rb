class DashboardController < ApplicationController
	def index
		@activity = Business.find(:all)
		@activity += Invoice.find(:all)
		@activity += Project.find(:all)
		@activity += Expense.find(:all)
		@activity += HourReport.find(:all)
		@activity += User.find(:all)
		@activity += Task.find(:all)

		@activity = @activity.sort { |x, y| 	y.created_at <=> x.created_at }
	
		respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @expenses }
    end
	end

end
