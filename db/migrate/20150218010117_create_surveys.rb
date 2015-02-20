class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.string :version 
      t.string :description 
      t.string :definition

      t.timestamps 
    end
  end
end
