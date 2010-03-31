class ProjectCost < ActiveRecord::Base
  validates_presence_of :name, :description, :task_id

  belongs_to :user
  belongs_to :task

  def get_cost
    nil
  end

  def get_state
    case self.state
    when 0 then 'Pending'
    when 1 then 'Approved'
    when 2 then 'Rejected'
    else 'Undefined'
    end
  end
end
