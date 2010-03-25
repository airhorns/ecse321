class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :country
      t.integer :addressable_id
      t.string :addressable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
