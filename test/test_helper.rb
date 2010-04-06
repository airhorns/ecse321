ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require "authlogic/test_case"
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
    should_eventually "be editable by a manager who manages a project for the associated business" do
    end
    should "not be editable by managers who aren't managing any projects for the buisness" do
      assert ! @extra_manager.can_update?(subject)
    end
  end
  
  def self.should_not_be_editable_by_employees
    should "not be editable by employees" do
      assert ! @user.can_update?(subject)
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
end
