class FixUserColumnName < ActiveRecord::Migration
  def change
    rename_column :users, :user_id, :username
  end
end
