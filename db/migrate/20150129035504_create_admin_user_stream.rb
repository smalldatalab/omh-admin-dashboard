class CreateAdminUserStream < ActiveRecord::Migration
  def change
    create_table :admin_user_streams do |t|
      t.belongs_to :data_stream, index: true
      t.belongs_to :admin_user, index: true

      t.timestamps 
    end
  end
end
