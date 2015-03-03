class AddColumnToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :public_to_all_users, :boolean, default: false
  end
end
