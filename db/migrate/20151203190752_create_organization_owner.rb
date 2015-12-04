class CreateOrganizationOwner < ActiveRecord::Migration
  def change
    create_table :organization_owners do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :admin_user, index: true
    end
  end
end
