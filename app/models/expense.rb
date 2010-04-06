class Expense < ProjectCost
<<<<<<< HEAD:app/models/expense.rb
  validates_presence_of :name
  validates_presence_of :cost
=======
  validates_presence_of :cost, :name
>>>>>>> 0fc4aed2cdb98c577b47cfe64ba6a3ac60605b85:app/models/expense.rb
  validates_numericality_of :cost, :greater_than => 0, :message => "- Cost must be a number greater than zero."
  validates_format_of :cost, :with => /\d+(\.\d{1,2})+\Z/, :message => "- Cost must have at most two digits after decimal point"

  def get_cost
    self.cost
  end

end
