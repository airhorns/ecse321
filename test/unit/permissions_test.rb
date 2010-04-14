require 'test_helper'
require 'pp'

$resources = [Address.new, Business.new, Contact.new, Expense.new, HourReport.new, Project.new, Task.new, Invoice.new, User.new]

$permissions_checked = {:admin => [], :employee => [], :manager => []}.inject({}) do |hash, (key, val)|
  hash[key] = $resources.inject({}) { |harsh, resource|
    name = resource.class.to_s.downcase.intern
    harsh[name] = case name
    when :hourreport, :expense
      {:create => false, :destroy => false, :view => false, :update => false, :approve => false, :reject => false}
    else
      {:create => false, :destroy => false, :view => false, :update => false, :approve => "nocall", :reject => "nocall"}
    end
    harsh
  }
  hash
end

class User
  after_permissions_query :after_query
  def after_query(options = {})
    role = options[:can].role
    role = role.intern if role.respond_to?(:intern)
    resource = options[:able].class.to_s.downcase.intern
    $permissions_checked[role][resource][options[:permission]] = true
  end
end


# Permissions specific test methods
class ActiveSupport::TestCase
  def self.should_allow_admin_crud
    should "be updatable by admin" do
      assert @admin.can_update?(subject)
    end
  end
  
  def self.should_allow_everyone_to_view
    should "be viewable by everyone" do
      @all_users.each do |user|
        assert user.can_view?(subject)
      end
    end
  end
  
  def self.should_only_be_destructable_by_admins
    should "not be destructable by anyone other than admins" do
      @not_admins.each do |user|
        assert ! user.can_destroy?(subject)
      end
    end
  end
  
  def self.should_only_be_editable_by_associated_project_managers
    should "be editable by a manager who manages an associated project" do
      assert @owning_manager.can_update?(subject)
    end
    should "not be editable by managers who aren't managing the associated project" do
      assert ! @extra_manager.can_update?(subject)
    end
  end
  
  def self.should_be_editable_by_all_managers
    should "be editable by all managers" do
      [@owning_manager, @extra_manager].each do |user|
        assert user.can_update?(subject)
      end
    end
  end
  
  def self.should_not_be_editable_by_employees
    should "not be editable by employees" do
      assert ! @user.can_update?(subject)
    end
  end
    
  def self.should_only_be_editable_by_creator_user
    should "be updatable by user who created it" do
      assert @owning_user.can_update?(subject)
    end
    should "not be updatable by a user who did not create it" do
      assert ! @extra_user.can_update?(subject)
    end
  end
  
  def self.should_only_allow_admins_to_destroy
    should "not be destructable by anyone except an administrator" do
      @not_admins.each do |user|
        assert ! user.can_destroy?(subject)
      end
      assert @admin.can_destroy?(subject)
    end
  end
  
  def self.should_allow_only_admin_crud
    should_allow_admin_crud
    Canable.actions.each do |can, able|
      method_name = "#{able}_by?".intern
      should "not allow non-admins to #{can}" do
        assert subject.respond_to?(method_name), "#{subject} doesn't respond to #{method_name}"
        @not_admins.each do |user|
          assert ! subject.send(method_name, user), "User #{user} of type #{user.canable_included_role} can #{can}."
        end
      end
    end
  end
  
  def self.project_cost_should_allow_associated_employees_to_create
    should "not be creatable by users if no task is specified" do
      @not_admins.each do |user|
        assert ! user.can_create?(Expense.new)
      end
    end
    should "be creatable by users associated with the project" do
      assert @associated_user.can_create?(Expense.new(:task => subject.task))
    end
    should "not be creatable by users who aren't associated with the project" do
      assert ! @extra_user.can_create?(Expense.new(:task => subject.task))
    end
  end
  
  def self.project_cost_should_be_destroyable_by_creator_user_if_not_approved
    should "not be destructable by non owning employees" do
      assert ! @extra_user.can_destroy?(subject)
    end
    should "be destructable by the owning user if the expense state is Pending" do
      subject.state = ProjectCost::Pending
      assert @owning_user.can_destroy?(subject)
    end
    should "be destructable by the owning user if the expense state is Rejected" do
      subject.state = ProjectCost::Rejected
      assert @owning_user.can_destroy?(subject)
    end
    should "not be destructable by the owning user if the expense state is Approved" do
      subject.state = ProjectCost::Approved
      assert ! @owning_user.can_destroy?(subject)
    end
  end
  
  def self.should_act_as_project_cost
    should_only_be_editable_by_creator_user
    should_only_be_editable_by_associated_project_managers
    project_cost_should_allow_associated_employees_to_create
    project_cost_should_be_destroyable_by_creator_user_if_not_approved
    
    should "allow approval and rejection by administrators" do
      assert @admin.can_approve?(subject)
      assert @admin.can_reject?(subject)
    end
    
    should "not allow approval or rejection by employees" do
      @employees.each do |user|
        assert ! user.can_approve?(subject)
        assert ! user.can_reject?(subject)
      end
    end
    
    should "be approvable and rejectable by project manager" do
      assert @owning_manager.can_approve?(subject)
      assert @owning_manager.can_reject?(subject)
    end
    
    should "not be approvable by managers who aren't managing the associated project" do
      assert ! @extra_manager.can_approve?(subject)
      assert ! @extra_manager.can_reject?(subject)
    end
  end
end

class PermissionsTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  context "Users with various permissions" do
    setup do
      @user = Factory.create(:user)
      @extra_user = Factory.create(:user, :email => "jim@gmail.com")
      
      @owning_manager = Factory.create(:manager) # manages the projects
      @extra_manager = Factory.create(:manager, :email => "manager@gmail.com") # does not manage the project
      @admin = Factory.create(:admin)
      
      # Shortcuts to iterate over
      @not_admins = [@user, @owning_manager, @extra_manager]
      @all_users = [@user, @owning_manager, @extra_manager, @admin]
      @employees = [@user, @extra_user]
      @owning_user = @user
      @associated_user = @user
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
          $resources.each do |resource|
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

class PermissionsTestTest < ActiveSupport::TestCase
  should "test all the roles on all the actions on all the resources" do
    permissions = table do |t|
      t.headings = "Role", "Resource", "view", "create", "update", "destroy", "approve", "reject"
      $permissions_checked.each do |role, resources|
        resources.each do |resource, actions|
          row = [role, resource] 
          [:view, :create, :update, :destroy, :approve, :reject].each do |p|
            row << actions[p]
            assert actions[p] == true || actions[p] == 'nocall', "#{p} was not checked for #{role} on #{resource}"
          end
          t << row
        end
      end
    end
    if self.display_tables
      puts 
      puts "Permissions Query Table -- shows every permissions query tested"
      puts permissions
    end
  end
end