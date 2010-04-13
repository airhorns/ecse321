require 'test_helper'

class HourReportTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  context "Hour reports with various permissions" do
    setup do
      @pending_cost = Factory.create(:pending)
      @appoved_cost = Factory.create(:approved)
      @rejected_cost = Factory.create(:rejected)
      @invoiced_cost = Factory.create(:invoiced)
    end

    should "return correct state strings" do
      assert_equal @pending_cost.state_to_s, 'Pending'
      assert_equal @appoved_cost.state_to_s, 'Approved'
      assert_equal @rejected_cost.state_to_s, 'Rejected'
      assert_equal @invoiced_cost.state_to_s, 'Invoiced'
    end
  end
end
