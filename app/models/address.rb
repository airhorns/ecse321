class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
  
  validates_presence_of :street1, :city, :zipcode, :country
  validate :state_must_belong_to_country, :if => Proc.new {|a| Carmen::states?(a.country) }
  
  after_initialize :default_region
  
  def to_s
    a = [self.street1,
      self.city,
      self.state,
      self.zipcode]
    a << Carmen::country_name(self.country) if self.country != Carmen.default_country  
    a.insert 1, self.street2 unless self.street2.blank?
    
    a.join(", ")
  end
  
  private
  def default_region
    if Carmen.default_country == "CA"
      self.country ||= "CA"
      self.state ||= "ON"
    end
  end
  def state_must_belong_to_country
    errors.add(:state, "must belong to the selected country") if Carmen::state_name(self.state, self.country).nil?
  end
end
