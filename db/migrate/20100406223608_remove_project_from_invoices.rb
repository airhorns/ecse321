class RemoveProjectFromInvoices < ActiveRecord::Migration
  def self.up
    remove_column :invoices, :project
  end

  def self.down
    add_column :invoices, :project, :string
  end
end
