class CreateUserStream < ActiveRecord::Migration
  def change
    create_table :user_streams do |t|
      t.belongs_to :user, index: true
      t.belongs_to :data_stream, index: true

      t.timestamps 
    end
  end
end
