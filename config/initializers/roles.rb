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
    end
  
    module ManagerRole
      include Canable::Role
      include EmployeeRole
    end

    module AdminRole
      include Canable::Role
      default_response true
    end
  end
end