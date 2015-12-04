class AddOrganizationToStudy < ActiveRecord::Migration
  def change
    change_table :studies do |t|
      t.belongs_to :organization, index: true
    end
  end
end