class Organization < ActiveRecord::Base
  has_many :studies, through: :organization_studies
  has_many :organization_studies

  has_many :organization_owners
  has_many :admin_users, through: :organization_owners

  has_many :surveys, through: :studies
  has_many :users, through: :studies

end