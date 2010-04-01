require 'test_helper'

class PermissionsTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  context "Some users with various permissions" do
    setup do
      @user = Factory.create(:user)
      @owning_manager = Factory.create(:manager) # manages the projects
      @extra_manager = Factory.create(:manager, :email => "manager@gmail.com") # does not manage the project
      @admin = Factory.create(:admin)
      
#      @project = Factory.create(:project, :manager => @owning_manager)
    end
    
    should "reflect their proper permissions" do
      assert_equal Canable::Roles::EmployeeRole, @user.canable_included_role
      assert_equal Canable::Roles::ManagerRole, @owning_manager.canable_included_role
      assert_equal Canable::Roles::ManagerRole, @extra_manager.canable_included_role
      assert_equal Canable::Roles::AdminRole, @admin.canable_included_role
    end
    
    context "and a business resource" do
      setup do
        @business = Factory.create(:business)
      end
      subject { @business }
      
      should_allow_admin_crud
      
      should_eventually "be editable by a manager who manages a project for the business" do
      end
      
      should "not be editable by employees" do
        assert ! @user.can_update?(@business)
      end
      
      should "not be editable by managers who aren't managing any projects for the buisness" do
        assert ! @extra_manager.can_update?(@business)
      end
      
    end
    
    context "and a contact resource" do
      setup do
        @contact = Factory.create(:contact)
      end
      
      subject { @contact }
      
      should_allow_admin_crud
      
      should "be editable by an administrator" do
      end
    end
  end
end
