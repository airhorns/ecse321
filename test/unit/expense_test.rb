require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  context "Expenses with various permissions" do
    setup do
      @pending_cost = Factory.create(:pending_expense)
      @appoved_cost = Factory.create(:approved_expense)
      @rejected_cost = Factory.create(:rejected_expense)
      @invoiced_cost = Factory.create(:invoiced_expense)
    end

    should "return correct state strings" do
      assert_equal @pending_cost.state_to_s, 'Pending'
      assert_equal @appoved_cost.state_to_s, 'Approved'
      assert_equal @rejected_cost.state_to_s, 'Rejected'
      assert_equal @invoiced_cost.state_to_s, 'Invoiced'
    end
  end
end
