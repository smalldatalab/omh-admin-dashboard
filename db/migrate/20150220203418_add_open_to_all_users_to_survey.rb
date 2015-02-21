class AddOpenToAllUsersToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :open_to_all_users, :boolean, default: false 
  end
end
