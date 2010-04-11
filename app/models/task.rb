class Task < ActiveRecord::Base
  include Canable::Ables
  
  has_many :project_costs
  belongs_to :project
  
  validates_presence_of :name, :project_id, :description
  
  def full_name
    self.name + ' - ' + self.project.name
  end
  
  def to_s
    self.name
  end
  
  def get_cost
    self.project_costs.inject(0) { |sum, cost| sum += cost.get_cost }
  end
  
  #under experiment
  def dtc
		sum = 0
	    mycosts = Array.new
		mycosts.concat(self.project_costs.find(:all, :conditions => {:date => start_date..end_date }))
		mycosts.each do |cost|
		  sum = sum + cost
		end
		return sum
	end
  
end
