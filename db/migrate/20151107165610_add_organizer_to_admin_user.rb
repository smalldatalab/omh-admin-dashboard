class AddOrganizerToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :organizer, :boolean, default: false
  end
end
