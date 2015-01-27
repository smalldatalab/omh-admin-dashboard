class CreateStudyOwners < ActiveRecord::Migration
  def change
    create_table :study_owners do |t|
      t.belongs_to :admin_user, index: true
      t.belongs_to :study, index: true 

      t.timestamps 
    end
  end
end
