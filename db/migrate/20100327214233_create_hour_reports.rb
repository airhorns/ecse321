class CreateHourReports < ActiveRecord::Migration
  def self.up
    create_table :hour_reports do |t|
      t.integer :hours

      t.timestamps
    end
  end

  def self.down
    drop_table :hour_reports
  end
end
