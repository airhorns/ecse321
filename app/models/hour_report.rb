class HourReport < ProjectCost
  validates_presence_of :hours
  validates_numericality_of :hours, :greater_than => 0, :only_integer => true, :message => "- Number of hours must be an integer greater than zero."

  def get_cost
    self.user.hourly_rate * self.hours
  end
end
