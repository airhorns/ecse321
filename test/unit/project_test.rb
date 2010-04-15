require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  context "Projects" do
    setup do
			@project = Factory.create(:project)

      @task1 = Factory.create(:task, :project => @project)
      @expense1 = Factory.create(:expense, :task => @task1)
      @hour_report1 = Factory.create(:hour_report, :task => @task1)

      @task2 = Factory.create(:task, :project => @project)
      @expense2 = Factory.create(:expense, :task => @task2)
      @hour_report2 = Factory.create(:hour_report, :task => @task2)
    end

    should "should have tasks" do
			assert @task1.project == @project
			assert @task2.project == @project
    end

    should "properly calculate the cost" do
			cost = @task1.get_cost + @task2.get_cost

			assert_equal @project.get_cost, cost
    end
  end
end
