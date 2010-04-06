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
    sum = 0
    self.project_costs.each do |c|
      sum = sum + c.get_cost
    end
    return sum
  end
  
end
