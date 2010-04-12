ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment") 
#Override Canable add method
module Canable
  private
    def self.add_can_method(can)
      Cans.module_eval <<-EOM
        def can_#{can}?(resource)
          self.__initialize_canable_role if self.class.include?(Canable::Actor)
          method = ("can_#{can}_"+resource.class.name.gsub(/::/,"_").downcase+"?").intern
          if self.respond_to?(method, true)
            self.send method, resource
          elsif self.respond_to?(:_canable_default)
            self._canable_default
          else
            false
          end
        end
      EOM
    end
end
require 'test_help'
require "authlogic/test_case"
#require File.expand_path(File.dirname(__FILE__) + "/../lib/colored_tests")

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
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
  
  def self.should_be_approvable_by_project_manager
    should "be approvable and rejectable by project manager" do
      assert @owning_manager.can_approve?(subject)
      assert @owning_manager.can_reject?(subject)
    end
    should "not be approvable by managers who aren't managing the associated project" do
      assert ! @extra_manager.can_approve?(subject)
      assert ! @extra_manager.can_reject?(subject)
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
  
  def self.should_not_allow_any_actions
    should "not permit access to the index action" do
      get :index
      assert_redirected_to(new_user_session_path)
    end
    should "not permit access to the new action" do
      get :new
      assert_redirected_to(new_user_session_path)
    end
    
    should "not permit access to the edit action" do
      get :edit, :id => Factory(:expense).id
      assert_redirected_to(new_user_session_path)
    end
    
    should "not permit access to the update action" do
      put :update, :id => Factory(:expense).id
      assert_redirected_to(new_user_session_path)
    end
    should "not permit access to the destroy action" do
      delete :destroy, :id => Factory(:expense).id
      assert_redirected_to(new_user_session_path)
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
    should_be_approvable_by_project_manager
    should_only_be_editable_by_creator_user
    project_cost_should_allow_associated_employees_to_create
    project_cost_should_be_destroyable_by_creator_user_if_not_approved
  end
end
