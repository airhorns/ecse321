# The +User+ class represents a physical person's account in the system. A person must have a 
# representation as a +User+ record to be able to interact with the system. Users can only be
# created by administrators.
# @author Harry Brundage
class User < ActiveRecord::Base
  include Canable::Actor
  include Canable::Ables
  default_role Canable::Roles::EmployeeRole
	has_and_belongs_to_many :projects
  
  role_proc Proc.new { |actor|
    actor.role
  }
  
  acts_as_authentic do |c|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
  end
  
  validates_presence_of :active, :first_name, :last_name, :hourly_rate, :telephone, :role
  
  def after_initialize
    if @attributes['role'].blank?
      @attributes['role'] = :employee
    end
  end
  
  def full_name
    self.first_name + " " + self.last_name
  end
  
  def to_s
    self.full_name
  end
end
