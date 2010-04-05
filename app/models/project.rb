class Project < ActiveRecord::Base
  include Canable::Ables
  
  has_many :project_costs
  belongs_to :business
  belongs_to :user
  has_many :tasks
  
  validates_presence_of :name, :notes, :due_date, :user_id, :business_id
  
  
  def get_cost
    sum = 0
    self.project_costs.each do |c|
      sum = sum + c.get_cost
    end
    return sum
  end
  
  def to_s
    self.name
  end
  
  
end
