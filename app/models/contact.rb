class Contact < ActiveRecord::Base
  include Canable::Ables
  has_one :address, :as => :addressable
  accepts_nested_attributes_for :address
  validates_associated :address
  
  validates_presence_of :name, :telephone
  
  belongs_to :business
end
