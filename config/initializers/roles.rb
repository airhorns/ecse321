Canable.add(:approve, :approvable)
Canable.add(:reject, :rejectable)
Canable.add(:save, :savable)

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
      

      # Project cost
      def can_update_project_cost?(project_cost)
        project_cost.user == self
      end

      def can_view_project_cost?(project_cost)
        can_update_project_cost?(project_cost) || can_approve_project_cost?(project_cost)
      end

      def can_view_hourreport?(hour_report)
        can_view_project_cost?(hour_report)
      end

      def can_view_expense?(expense)
        can_view_project_cost?(expense)
      end

      def can_update_hourreport?(hour_report)
        can_update_project_cost?(hour_report)
      end

      def can_update_expense?(expense)
        can_update_project_cost?(expense)
      end

      def can_save_project_cost?(project_cost)
        self.projects.include?(project_cost.task.project)
      end
      
      def can_create_expense?(expense)
        self.active
      end
      
      def can_create_hourreport?(hour_report)
        self.active
      end

      def can_save_expense?(expense)
        can_save_project_cost?(expense)
      end

      def can_save_hourreport?(hour_report)
        can_save_project_cost?(hour_report)
      end
    
    end
  
    module ManagerRole
      include Canable::Role
      include EmployeeRole
      
      # Projects and Tasks
      def can_create_project?(project)
        can_update_project?(project)
      end
      
      def can_create_task?(task)
        #can_update_project?(task.project)
        true
      end
      
      def can_update_project?(project)
        project.user == self
      end
      
      
      # Project Costs
      def can_approve_project_cost?(project_cost)
        project_cost.task.project.user == self
      end
      
      def can_reject_project_cost?(project_cost)
        can_approve_project_cost?(project_cost)
      end
      
      def can_approve_expense?(project_cost)
        can_approve_project_cost?(project_cost)
      end
      
      def can_reject_expense?(project_cost)
        can_approve_project_cost?(project_cost)
      end
      
      def can_approve_hourreport?(project_cost)
        can_approve_project_cost?(project_cost)
      end
      
      def can_reject_hourreport?(project_cost)
        can_approve_project_cost?(project_cost)
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
      
    end

    module AdminRole
      include Canable::Role
      default_response true
    end
  end
end


