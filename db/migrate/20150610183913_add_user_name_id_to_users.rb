class AddUserNameIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_name_id, :string
  end
end
