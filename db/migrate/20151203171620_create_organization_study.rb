class CreateOrganizationStudy < ActiveRecord::Migration
  def change
    create_table :organization_studies do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :study, index: true

    end
  end
end
