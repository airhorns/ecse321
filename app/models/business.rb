class Business < ActiveRecord::Base
  #has_many :contacts
  has_one :address, :dependent => :destroy, :as => :addressable
  accepts_nested_attributes_for :address
  validates_associated :address
  
  validates_presence_of :name, :telephone
  def to_s
    self.name
  end
end