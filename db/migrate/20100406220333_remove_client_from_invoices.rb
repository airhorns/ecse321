class RemoveClientFromInvoices < ActiveRecord::Migration
  def self.up
    remove_column :invoices, :client
  end

  def self.down
    add_column :invoices, :client, :string
  end
end
