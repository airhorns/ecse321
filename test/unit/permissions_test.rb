require 'test_helper'

class PermissionsTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  context "Users with various permissions" do
    setup do
      @user = Factory.create(:user)
      @owning_manager = Factory.create(:manager) # manages the projects
      @extra_manager = Factory.create(:manager, :email => "manager@gmail.com") # does not manage the project
      @admin = Factory.create(:admin)
      
      @not_admins = [@user, @owning_manager, @extra_manager]
      @all_users = [@user, @owning_manager, @extra_manager, @admin]
#      @project = Factory.create(:project, :manager => @owning_manager)
    end
    
    should "reflect their proper permissions" do
      assert_equal Canable::Roles::EmployeeRole, @user.canable_included_role
      assert_equal Canable::Roles::ManagerRole, @owning_manager.canable_included_role
      assert_equal Canable::Roles::ManagerRole, @extra_manager.canable_included_role
      assert_equal Canable::Roles::AdminRole, @admin.canable_included_role
    end
    
    context "and a user resource, the user resource (profile)" do
      setup do
        @new_user = Factory.create(:new_user)
      end
      subject { @new_user }
      should_allow_admin_crud
      should_allow_everyone_to_view
      should_only_be_destructable_by_admins
      
      should "not be creatable by users if they aren't administrators" do
        @not_admins.each do |user|
          assert ! user.can_create?(@new_user)
        end
      end
      
      should "not be editable unless the user is editing their own profile" do
        @all_users.each do |user|
          assert user.can_update?(user)
        end
      end
      
      should "not be editable by anyone else" do
        @not_admins.each do |user|
          @all_users.each do |resource|
            assert ! user.can_update?(resource) if user != resource
          end
        end
      end
      
    end
    
    context "and a business resource, the resource" do
      setup do
        @business = Factory.create(:business)
      end
      subject { @business }
      
      should_allow_admin_crud
      should_allow_everyone_to_view
      should_only_be_destructable_by_admins
      should_only_be_editable_by_associated_project_managers
      should_not_be_editable_by_employees
    end
    
    context "and a contact resource, the resource" do
      setup do
        @contact = Factory.create(:contact)
      end
      subject { @contact }      
      
      should_allow_admin_crud
      should_allow_everyone_to_view
      should_only_be_destructable_by_admins
      should_only_be_editable_by_associated_project_managers
      should_not_be_editable_by_employees

    end
    
    context "and an address resource, the resource" do
      setup do
        @business = Factory.create(:business)
        @address = @business.address
      end
      subject { @address }      
      
      should_allow_admin_crud
      should_allow_everyone_to_view
      should_only_be_destructable_by_admins
      should_only_be_editable_by_associated_project_managers
      should_not_be_editable_by_employees
      
    end
    
    context "and an expense resource" do
      setup do
        #@expense = Factory.create(:expense, :project => @project)
      end
      
    end
    
    context "and an hour report resource" do
      setup do
        #@expense = Factory.create(:expense, :project => @project)
      end
      
    end
    
    context "and a project resource, the project resource" do
      setup do
        @project = Factory.create(:project, :user => @owning_manager)
      end
      
      should "not be updatable by a non owning manager" do
        assert ! @project.updatable_by?(@extra_manager)
        assert ! @extra_manager.can_update?(@project)
      end
      
      should "be updatable by the project manager" do
        assert @project.updatable_by?(@owning_manager)
        assert @owning_manager.can_update?(@project)
      end
      
      should "be editable by an admin" do
        assert @admin.can_update?(@project)
      end
      
      should "not be editable by a user" do
        assert ! @user.can_update?(@project)
      end
      
      should "not be destructable by anyone except an administrator" do
        @not_admins.each do |user|
          assert ! user.can_destroy?(@project)
        end
        assert @admin.can_destroy?(@project)
      end
    end
  end
end
