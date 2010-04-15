require 'test_helper'

class HourReportTest < ActiveSupport::TestCase

  context "Tasks" do
    setup do
      @task = Factory.create(:task)
      @expense = Factory.create(:expense, :task => @task)
      @hour_report = Factory.create(:hour_report, :task => @task)
    end

    should "should have project costs" do
			assert @expense.task == @task
			assert @hour_report.task == @task
    end

    should "properly calculate the cost" do
			cost = @expense.get_cost + @hour_report.get_cost

			assert_equal @task.get_cost, cost
    end
  end
end
