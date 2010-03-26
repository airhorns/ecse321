class CreateBusinesses < ActiveRecord::Migration
  def self.up
    create_table :businesses do |t|
      t.string :name
      t.string :website
      t.string :telephone
      t.string :fax
      t.string :email
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :businesses
  end
end
