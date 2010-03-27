require 'test_helper'

class ProjectCostsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_costs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_cost" do
    assert_difference('ProjectCost.count') do
      post :create, :project_cost => { }
    end

    assert_redirected_to project_cost_path(assigns(:project_cost))
  end

  test "should show project_cost" do
    get :show, :id => project_costs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => project_costs(:one).to_param
    assert_response :success
  end

  test "should update project_cost" do
    put :update, :id => project_costs(:one).to_param, :project_cost => { }
    assert_redirected_to project_cost_path(assigns(:project_cost))
  end

  test "should destroy project_cost" do
    assert_difference('ProjectCost.count', -1) do
      delete :destroy, :id => project_costs(:one).to_param
    end

    assert_redirected_to project_costs_path
  end
end
