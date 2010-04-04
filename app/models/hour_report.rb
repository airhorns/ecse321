class HourReport < ProjectCost
  validates_presence_of :hours

  def get_cost
    self.user.hourly_rate * self.hours
  end
end
