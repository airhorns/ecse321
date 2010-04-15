require 'test_helper'

class ExpensesControllerTest < ActionController::TestCase
  setup :activate_authlogic
  should_not_allow_any_actions_if_not_logged_in
  
  context "With a logged in administrator user, the controller" do
    setup do
      @user = Factory.create(:admin)
      @expense = Factory.create(:expense)
      @task = @expense.task
      @user_session = UserSession.new(:user => @user)
    end
    
    should "get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:expenses)
    end

    should "get new" do
      get :new
      assert_response :success
    end

    should "create expense" do
      attributes =  Factory.attributes_for(:expense)
      attributes[:task] = @task
      
      assert_difference('Expense.count') do
        post :create, :expense => attributes
      end

      assert_redirected_to expense_path(assigns(:expense))
    end

    should "show an expense" do
      get :show, :id => @expense.to_param
      assert_response :success
    end

    should "get edit" do
      get :edit, :id => @expense.to_param
      assert_response :success
    end

    should "update an expense" do
      put :update, :id => @expense.to_param, :expense => Factory.attributes_for(:expense, :name => "Gobbledeegook")
      assert_redirected_to expense_path(assigns(:expense))
    end

    should "destroy an expense" do
      assert_difference('Expense.count', -1) do
        delete :destroy, :id => @expense.to_param
      end

      assert_redirected_to expenses_path
    end
  end
end