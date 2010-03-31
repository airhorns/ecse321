class Expense < ProjectCost
  validates_presence_of :cost

  def get_cost
    @cost
  end
end
