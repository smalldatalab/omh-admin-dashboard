class AddOrganizationToSurveys < ActiveRecord::Migration
  def change
    change_table :surveys do |t|
      t.belongs_to :organization, index: true
    end
  end
end