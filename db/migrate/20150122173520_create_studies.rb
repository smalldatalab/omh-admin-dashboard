class CreateStudies < ActiveRecord::Migration
  def change
    create_table :studies do |t|
      t.belongs_to :admin_user, index: true
      t.belongs_to :user, index: true
      t.string :name
      
      t.datetime :study_date

      t.timestamps
    end
  end
end
