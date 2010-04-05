class ModifyProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :user_id, :int
    add_column :projects, :client_id, :int
  end

  def self.down
    remove_column :projects, :user_id
    remove_column :projects, :client_id
  end
end
