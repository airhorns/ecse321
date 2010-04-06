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
      
      # ProjectCost permissions for Employees
      # view: only those reported by themselves
      # update: only those reported by themselves
      # destroy: never
      # create: never
      def can_view_hour_report?(project_cost)
        project_cost.user == self
      end

      # ProjectCost permissions for Employees
      # view: only those reported by themselves
      # update: only those reported by themselves
      # destroy: never
      # create: never
      def can_update_project_cost?(project_cost)
        project_cost.user == self
      end
      def can_create_expense?(project_cost)
        true
      end

    end
  
    module ManagerRole
      include Canable::Role
      include EmployeeRole
      
      def can_update_project?(project)
        project.user == self
      end
      
      def can_approve_project_cost?(project_cost)
        project_cost.project.user == self
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
      
      def can_approve_hour_report?(project_cost)
        can_approve_project_cost?(project_cost)
      end
      
      def can_reject_hour_report?(project_cost)
        can_approve_project_cost?(project_cost)
      end
    end

    module AdminRole
      include Canable::Role
      default_response true
    end
  end
end


