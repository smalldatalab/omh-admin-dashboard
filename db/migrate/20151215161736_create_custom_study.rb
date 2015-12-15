class CreateCustomStudy < ActiveRecord::Migration
  def change
    create_table :custom_studies do |t|
      t.belongs_to :study, index: true
      t.belongs_to :custom_user, index: true
    end
  end
end
