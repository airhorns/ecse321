class DashboardController < ApplicationController
  before_filter :require_user
	def index
	  sql = {:order => "updated_at DESC", :limit => 10}
		@activity = Business.find(:all, sql)
		@activity += Invoice.find(:all, sql)
		@activity += Project.find(:all, sql)
		@activity += ProjectCost.find(:all, sql)
		@activity += User.find(:all, sql)
		@activity += Task.find(:all, sql)

		@activity = @activity.sort { |x, y| 	y.created_at <=> x.created_at }
	
		respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @expenses }
    end
	end

end
