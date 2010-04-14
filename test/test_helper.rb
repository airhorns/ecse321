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
require 'terminal-table/import'

class ActiveSupport::TestCase
  cattr_accessor :display_tables
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
  fixtures :all #-- We're using FactoryGirl instead

  # Add more helper methods to be used by all tests here...
  def self.should_not_allow_any_actions_if_not_logged_in
    context "without a logged in user, the controller" do
      setup do
        assert @current_user == nil
      end
      
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
end

ActiveSupport::TestCase.display_tables = true if ENV['TABLES']