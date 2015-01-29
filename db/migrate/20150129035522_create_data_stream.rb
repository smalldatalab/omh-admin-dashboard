class CreateDataStream < ActiveRecord::Migration
  def change
    create_table :data_streams do |t|
      t.string :name 

      t.timestamps 
    end
  end
end
