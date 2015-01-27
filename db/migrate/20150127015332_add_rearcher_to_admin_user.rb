class AddRearcherToAdminUser < ActiveRecord::Migration
  def change
  	add_column :admin_users, :researcher, :boolean, default: false
  end
end
