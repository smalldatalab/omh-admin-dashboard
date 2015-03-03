class DropTables < ActiveRecord::Migration
  def change
    drop_table :study_surveys, :study_streams
  end
end
