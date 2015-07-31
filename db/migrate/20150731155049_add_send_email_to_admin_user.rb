class AddSendEmailToAdminUser < ActiveRecord::Migration
 def change
    add_column :admin_users, :send_email, :boolean, default: false
  end
end
