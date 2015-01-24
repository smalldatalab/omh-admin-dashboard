class FixColumnName < ActiveRecord::Migration
  def change
  	remove_column :users, :study_name, :studies
  end
end
