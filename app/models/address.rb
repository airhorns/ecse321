class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
  
  validates_presence_of :street1, :city, :zipcode, :country
  
  # Ensure the specified state/province belongs to the specified country. Called only if the specified country actually has states. 
  validate :state_must_belong_to_country, :if => Proc.new {|a| Carmen::states?(a.country) }
  
  after_initialize :default_region
  
  # Overrides +Object.to_s+ to print out a well formatted address. Includes the country if it is not standard (not the +Carmen.default_country+) and the second street line if it exists.
  # @return [String] the address represented as a well formatted string
  def to_s
    a = [self.street1, self.city, self.state, self.zipcode]
    a << Carmen::country_name(self.country) if self.country != Carmen.default_country  
    a.insert 1, self.street2 unless self.street2.blank?  
    a.join(", ")
  end
  
  private
  
  # Sets the object's default region when it is instantiated. Called by the +after_initialize+ callback.
  def default_region
    if Carmen.default_country == "CA"
      self.country ||= "CA"
      self.state ||= "ON"
    end
  end
  
  # Validation check to ensure the specified state/province belongs to the specified country. Adds to the Rails supplied +errors+ validation error array.
  # @return [Boolean] the result of the validation
  def state_must_belong_to_country
    errors.add(:state, "must belong to the selected country") if Carmen::state_name(self.state, self.country).nil?
  end
end
