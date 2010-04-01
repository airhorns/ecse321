class HourReport < ProjectCost
  validates_presence_of :hours

  def get_cost
    # to be implemented
    0
  end
end
