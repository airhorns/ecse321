require 'test_helper'

class PermissionsTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  context "Some users with various permissions" do
    setup do
      @user = Factory.create(:user)
      @manager = Factory.create(:manager)
      @manager2 = User.new(:email => "lol@lol.com", :password => "sdfsdf", :password_confirmation => "sdfsdf", :role => :manager)
      @admin = Factory.create(:admin)
    end
    
    should "reflect their proper permissions" do
      assert_equal Canable::Roles::EmployeeRole, @user.canable_included_role
      assert_equal Canable::Roles::ManagerRole, @manager2.canable_included_role
      assert_equal Canable::Roles::ManagerRole, @manager.canable_included_role
      assert_equal Canable::Roles::AdminRole, @admin.canable_included_role
    end
    
    context "and a business resource" do
      setup do
        @business = Factory.create(:business)
      end
      
      should "be editable by an administrator" do
        puts @admin.inspect
        assert @admin.can_update?(@business)
        assert @business.updatable_by?(@admin)
      end
      
      should_eventually "be editable by a manager who manages a project for the business" do
      end
      
      should "not be editable by employees" do
        assert ! @employee.can_update(@business)
      end
    end
  end
end
