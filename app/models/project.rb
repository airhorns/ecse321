class Project < ActiveRecord::Base
  include Canable::Ables
  
  has_many :project_costs
  belongs_to :business
  belongs_to :user
  has_many :tasks
  has_and_belongs_to_many :users
  
  validates_presence_of :name, :notes, :due_date, :user_id, :business_id
  
  
  def get_cost
    self.tasks.inject(0) { |sum, cost| sum += cost.get_cost }
  end
  
  def to_s
    self.name
  end
  
  def project
    self.task.project
  end
  
  def manager
    self.user
  end
end
