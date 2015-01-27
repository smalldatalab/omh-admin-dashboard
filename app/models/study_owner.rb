class StudyOwner < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :study

  validates_presence_of :admin_user
  validates_presence_of :study
end 