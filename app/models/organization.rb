class Organization < ActiveRecord::Base
  has_many :studies
  has_many :surveys
  has_many :users

  has_many :admin_users

end