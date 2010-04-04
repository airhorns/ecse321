class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string    :name,    :limit => 255,    :null => false
      t.text      :notes,   :default => 'No notes recorded.',     :null => false
      t.datetime  :due_date

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
