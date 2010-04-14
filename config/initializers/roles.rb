
Canable.add(:approve, :approvable)
Canable.add(:reject, :rejectable)

module ECSE321
  module PermissionHelpers
    def is_owner?(resource)
      if resource.respond_to?(:user)
        self == resource.user
      else 
        false
      end
    end
    
    def is_project_manager?(project)
      if project
        project.manager == self
      else
        false
      end
    end
    
    def is_part_of_project?(project)
      is_project_manager?(project) || self.projects.include?(project)
    end
      
    def reported_cost_or_manager_of_parent_project?(project_cost)
      is_owner?(project_cost) || is_project_manager?(project_cost.project)
    end
    
  end
end

module Canable
  module Roles
    
    module EmployeeRole
      include Canable::Role
      include ECSE321::PermissionHelpers
      default_response false
      
      # User permissions for Employees
      # view: always
      # update: users may only edit themselves
      # destroy: never
      # create: never
      
      def can_view_user?(user)
        true
      end
      
      def can_update_user?(user)
        self == user
      end
      
      # Contact permissions for Employees
      # view: always
      # update: never
      # destroy: never
      # create: never
      
      def can_view_contact?(contact)
        true
      end
      
      # Business permissions for Employees
      # view: always
      # update: never
      # destroy: never
      # create: never
      
      def can_view_business?(business)
        true
      end
      
      # Address permissions for Employees
      # view: always
      # update: never
      # destroy: never
      # create: never
      
      def can_view_address?(business)
        true
      end
      
      # Project permissions for Employees
      # view: only those the user is associated with
      # update: none
      # destroy: never
      # create: always

      def can_view_project?(project)
        is_part_of_project?(project)
      end
      
      # ProjectCost permissions for Employees
      # view: only those reported by themselves
      # update: only those reported by themselves
      # destroy: never
      # create: only for projects the employee is associated with
      
      def can_update_project_cost?(project_cost)
        is_owner?(project_cost)
      end

      def can_view_project_cost?(project_cost)
        is_owner?(project_cost)
      end
      
      def can_create_project_cost?(project_cost)
        is_part_of_project?(project_cost.project)
      end
      
      def can_destroy_project_cost?(project_cost)
        is_owner?(project_cost) && (project_cost.state == ProjectCost::Pending || project_cost.state == ProjectCost::Rejected)
      end
      
      # Hour Report permissions for Employees
      # view: only those reported by themselves
      # update: only those reported by themselves
      # destroy: never
      # create: only for projects the employee is associated with
      
      # Hour Report permissions for Employees
      # view: only those reported by themselves
      # update: only those reported by themselves
      # destroy: never
      # create: only for projects the employee is associated with
      
      ['expense', 'hourreport'].each do |able|
        ['view', 'update', 'create', 'destroy'].each do |can|
          define_method("can_#{can}_#{able}?".intern) do |project_cost|
            self.send("can_#{can}_project_cost?", project_cost)
          end
        end
      end
      
    end
  
    module ManagerRole
      include Canable::Role
      include ECSE321::PermissionHelpers
      include EmployeeRole
      
      
      # User permissions for Managers
      # Inherited from Employee
      # view: always
      # update: users may only edit themselves
      # destroy: never
      # create: never
      
      # Contact permissions for Managers
      # Inherited from Employee
      # view: always
      # update: never
      # destroy: never
      # create: never
      
      # Business permissions for Managers
      # Inherited from Employee
      # view: always
      # update: never
      # destroy: never
      # create: never
      
      # Address permissions for Managers
      # Inherited from Employee
      # view: always
      # update: never
      # destroy: never
      # create: never
      
      # Project permissions for Managers
      # view: only those the manager is associated with or managing
      # update: only those managed by themselves
      # destroy: never
      # create: never
      
      def can_view_project?(project)
        is_part_of_project?(project)
      end
      
      def can_update_project?(project)
        is_project_manager?(project)
      end
      
      # Task permissions for Managers
      # view: only tasks belonging to a project the manager is associated with or managing
      # update: only tasks belonging to a project the manager is managing
      # destroy: never
      # create: always
      
      def can_view_task?(task)
        can_view_project?(task.project)
      end
      
      def can_create_task?(task)
        is_project_manager?(task.project)
      end
      
      def can_update_task?(task)
        is_project_manager?(task.project)
      end
      
      # ProjectCost permissions for Managers
      # view: only costs belonging to tasks belonging to a project the manager is managing or reported themself
      #       not costs belonging to projects the manager is only associated with but not managing
      # update: only costs belonging to tasks only tasks belonging to a project the manager is managing or reported themself
      # destroy: only costs belonging to tasks only tasks belonging to a project the manager is managing
      #          not costs reported by the manager but not belonging to a project they are mananging
      # create: only costs belonging to tasks only tasks belonging to a project the manager is associated with or managing
      # approve: only costs belonging to tasks only tasks belonging to a project the manager is managing
      # reject: only costs belonging to tasks only tasks belonging to a project the manager is managing
      
      def can_view_project_cost?(project_cost)
        reported_cost_or_manager_of_parent_project?(project_cost)
      end
      
      def can_update_project_cost?(project_cost)
        reported_cost_or_manager_of_parent_project?(project_cost)
      end 
      
      def can_destroy_project_cost?(project_cost)
        is_project_manager?(project_cost.project)
      end
      
      def can_create_project_cost?(project_cost)
        is_part_of_project?(project_cost.project)
      end
      
      def can_approve_project_cost?(project_cost)
        is_project_manager?(project_cost.project)
      end
      
      def can_reject_project_cost?(project_cost)
        is_project_manager?(project_cost.project)
      end
      
      ['expense', 'hourreport'].each do |able|
        ['view', 'update', 'destroy', 'create', 'approve', 'reject'].each do |can|
          define_method("can_#{can}_#{able}?".intern) do |project_cost|
            self.send("can_#{can}_project_cost?", project_cost)
          end
        end
      end      
      
      # Businesses and Contacts
      def can_create_contact?(contact)
        true
      end
      
      def can_create_business?(business)
        true
      end
      
      def can_update_business?(business)
        true
      end
      
      def can_update_contact?(contact)
        true
      end
      
      def can_update_address?(address)
        true
      end
    end

    module AdminRole
      include Canable::Role
      default_response true
    end
    #|| can_approve_project_cost?(project_cost)
  end
end