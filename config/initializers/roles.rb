Canable.add(:approve, :approvable)
Canable.add(:reject, :rejectable)

module Canable
  module Roles
    
    module EmployeeRole
      include Canable::Role
      default_response false
    
      def is_owner?(resource)
        if resource.respond_to?(:user)
          self == resource.user
        else 
          false
        end
      end
      
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
      def is_part_of_project?(project)
        is_project_manager?(project) || self.projects.include?(project)
      end
      
      
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
        is_part_of_project?(project)
      end
      
      # Hour Report permissions for Employees
      # view: only those reported by themselves
      # update: only those reported by themselves
      # destroy: never
      # create: only for projects the employee is associated with
      
      def can_view_hourreport?(hour_report)
        can_view_project_cost?(hour_report)
      end
      
      def can_update_hourreport?(hour_report)
        can_update_project_cost?(hour_report)
      end
      
      def can_create_hourreport?(hour_report)
        can_create_project_cost?(hour_report)
      end
      
      # Hour Report permissions for Employees
      # view: only those reported by themselves
      # update: only those reported by themselves
      # destroy: never
      # create: only for projects the employee is associated with
      
      def can_view_expense?(expense)
        can_view_project_cost?(expense)
      end
      
      def can_update_expense?(expense)
        can_update_project_cost?(expense)
      end
            
      def can_create_expense?(expense)
        can_create_project_cost?(expense)
      end
    end
  
    module ManagerRole
      include Canable::Role
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
      
      def is_project_manager?(project)
        project.manager == self
      end
      
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
        is_project_manager?(project)
      end
      
      def can_update_task?(task)
        is_project_manager?(project)
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
      
      def reported_cost_or_manager_of_parent_project?(project_cost)
        is_owner?(project_cost) || is_project_manager?(project_cost.project)
      end
      
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
        is_part_of_project?(project.project_cost)
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