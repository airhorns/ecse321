# A +Business+ object represents a client of the users of the PMS. It's used to track contact information about
# +Contact+s and categorize their origin. 
# @author Harry Brundage
class Business < ActiveRecord::Base
  include Canable::Ables
  has_many :contacts
  
  # Receiving end of the polymorphic address association
  has_one :address, :dependent => :destroy, :as => :addressable
  accepts_nested_attributes_for :address
  validates_associated :address
  
  # Make sure all businesses have names and telephone numbers.
  validates_presence_of :name, :telephone
  
  # Overrides +Object.to_s+ to provide a simple description of the business, its name.
  # @return [String] the well formatted name of the +Business+
  def to_s
    self.name
  end
end