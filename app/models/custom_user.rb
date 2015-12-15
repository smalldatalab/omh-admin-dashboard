class CustomUser < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :username
  validates :studies, presence: true

  has_many :custom_studies
  has_many :studies, through: :custom_studies

end