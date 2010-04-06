class Expense < ProjectCost
  validates_presence_of :name
  validates_presence_of :cost
  validates_numericality_of :cost, :greater_than => 0, :message => "- Cost must be a number greater than zero."
  validates_format_of :cost, :with => /\d+(\.\d{1,2})+\Z/, :message => "- Cost must have at most two digits after decimal point"

  def get_cost
    self.cost
  end

end
