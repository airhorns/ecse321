class ChangeFromClientToBusinessOnProject < ActiveRecord::Migration
  def self.up
    remove_column :projects, :client_id
    add_column :projects, :business_id, :int
  end

  def self.down
    remove_column :projects, :business_id
    add_column :projects, :client_id, :int
  end
end
