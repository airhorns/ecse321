class AddDetailsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :active, :boolean
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :hourly_rate, :decimal
    add_column :users, :telephone, :string
    add_column :users, :employee_number, :string
  end

  def self.down
    remove_column :users, :employee_number
    remove_column :users, :telephone
    remove_column :users, :hourly_rate
    remove_column :users, :last_name
    remove_column :users, :first_name
    remove_column :users, :active
  end
end
