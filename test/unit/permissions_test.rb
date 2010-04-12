require 'test_helper'
class PermissionsTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  context "Users with various permissions" do
    setup do
      @user = Factory.create(:user)
      @owning_user = @user
      @associated_user = @user
      @extra_user = Factory.create(:user, :email => "jim@gmail.com")
      
      @owning_manager = Factory.create(:manager) # manages the projects
      @extra_manager = Factory.create(:manager, :email => "manager@gmail.com") # does not manage the project
      @admin = Factory.create(:admin)
      
      @not_admins = [@user, @owning_manager, @extra_manager]
      @all_users = [@user, @owning_manager, @extra_manager, @admin]
    end
    
    should "reflect their proper permissions" do
      assert_equal Canable::Roles::EmployeeRole, @user.canable_included_role
      assert_equal Canable::Roles::ManagerRole, @owning_manager.canable_included_role
      assert_equal Canable::Roles::ManagerRole, @extra_manager.canable_included_role
      assert_equal Canable::Roles::AdminRole, @admin.canable_included_role
    end
    
    should "be able to operate on new objects" do
      assert_nothing_raised(Exception) do
        @all_users.each do |user|
          [Address.new, Business.new, Contact.new, Expense.new, HourReport.new, Project.new, Task.new, Invoice.new, User.new].each do |resource|
            user.can_view?(resource)
            user.can_update?(resource)
            user.can_destroy?(resource)
            user.can_create?(resource)
          end
        end
      end
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
      should_be_editable_by_all_managers
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
      should_be_editable_by_all_managers
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
      should_be_editable_by_all_managers
      should_not_be_editable_by_employees
      
    end
    context "and a project resource, the project resource" do
      setup do
        @project = Factory.create(:project, :user => @owning_manager, :users => [@associated_user])
      end
      subject { @project }    
      
      should_allow_admin_crud
      should_only_be_editable_by_associated_project_managers
      should_not_be_editable_by_employees
      should_only_allow_admins_to_destroy

      context "with tasks" do
        setup do
          tasks = []
          3.times do 
            tasks << Factory.create(:task, :project => @project)
          end
          @task1 = tasks.first
        end
        subject { @task1 }
        
        should_allow_admin_crud
        should_only_be_editable_by_associated_project_managers
        should_not_be_editable_by_employees
        should_only_allow_admins_to_destroy
        
        context "and an valid expense resource, the expense resource" do
          setup do
            @expense = Factory.create(:expense, :task => @task1, :user => @owning_user)
          end
          subject { @expense }
          
          should_act_as_project_cost
          
        end

        context "and an hour report resource, the hour report resource" do
          setup do
            @hour_report = Factory.create(:hour_report, :task => @task1, :user => @owning_user)
          end
          subject { @hour_report }
          
          should_act_as_project_cost
          
        end
        
        context "and an invoice resource, the invoice resource" do
          setup do
            @invoice = Factory.create(:invoice, :project => @project)
          end
          subject { @invoice }
          should_allow_only_admin_crud
        end
      end
    end
  end
end
