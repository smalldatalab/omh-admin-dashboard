class CreateCustomUsers < ActiveRecord::Migration
  def change
    create_table :custom_users do |t|
      t.string :username
      t.string :password
      t.string :password_digest
      t.string :annotation

      t.timestamps
    end
  end
end
