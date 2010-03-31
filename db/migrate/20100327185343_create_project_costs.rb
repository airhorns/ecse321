class CreateProjectCosts < ActiveRecord::Migration
  def self.up
    create_table :project_costs do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.integer :task_id
      t.date :date
      t.integer :hours
      t.float :cost
      t.integer :state
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :project_costs
  end
end
