class CreateProjectCosts < ActiveRecord::Migration
  def self.up
    create_table :project_costs do |t|
      t.string :name
      t.text :description
      t.int :user_id
      t.int :task_id
      t.datetime :date
      t.int :state
			t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :project_costs
  end
end
