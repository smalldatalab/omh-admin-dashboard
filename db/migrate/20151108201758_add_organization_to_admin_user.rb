class AddOrganizationToAdminUser < ActiveRecord::Migration
  def change
    change_table :admin_users do |t|
      t.belongs_to :organization, index: true

    end
  end
end
