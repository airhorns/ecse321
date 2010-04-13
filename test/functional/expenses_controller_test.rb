require 'test_helper'

class ExpensesControllerTest < ActionController::TestCase
  setup :activate_authlogic
  context "Without a logged in user" do
    should_not_allow_any_actions_if_not_logged_in
  end
  
  context "With a logged in administrator user" do
    setup do
      @user_session = UserSession.new Factory.create(:admin)
      @user = @user_session.user
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
      assert_difference('Expense.count') do
        post :create, :expense => { }
      end

      assert_redirected_to expense_path(assigns(:expense))
    end

    should "show expense" do
      get :show, :id => expenses(:one).to_param
      assert_response :success
    end

    should "get edit" do
      get :edit, :id => expenses(:one).to_param
      assert_response :success
    end

    should "update expense" do
      put :update, :id => expenses(:one).to_param, :expense => { }
      assert_redirected_to expense_path(assigns(:expense))
    end

    should "destroy expense" do
      assert_difference('Expense.count', -1) do
        delete :destroy, :id => expenses(:one).to_param
      end

      assert_redirected_to expenses_path
    end
  end
  
end
