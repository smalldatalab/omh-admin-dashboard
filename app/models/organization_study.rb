class OrganizationStudy < ActiveRecord::Base
  belongs_to :organization
  belongs_to :study

  validates_presence_of :organization
  validates_presence_of :study
end