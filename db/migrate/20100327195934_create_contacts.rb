class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :name
      t.string :department
      t.string :telephone
      t.string :mobile
      t.string :fax
      t.string :email
      t.text :notes
      t.integer :business_id 
      
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
