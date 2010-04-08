# A +ProjectCost+ represent the notion of any cost related to a project.
# @author Shen Chen Xu
class ProjectCost < ActiveRecord::Base
  include Canable::Ables
	
  validates_presence_of :description, :user_id, :task_id, :name


  belongs_to :user
  belongs_to :task

  Pending = 0
  Approved = 1
  Rejected = 2

  def state_to_s
    case self.state
      when Pending then 'Pending'
      when Approved then 'Approved'
      when Rejected then 'Rejected'
      else 'Undefined'
    end
  end

  def cost_to_s
    sprintf( "$%.2f", self.get_cost )
  end

end
