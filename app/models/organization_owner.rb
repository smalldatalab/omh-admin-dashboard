class OrganizationOwner < ActiveRecord::Base
  belongs_to :organization
  belongs_to :admin_user

  validates_presence_of :organization
  validates_presence_of :admin_user
end