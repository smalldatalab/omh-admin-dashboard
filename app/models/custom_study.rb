class CustomStudy < ActiveRecord::Base
  belongs_to :custom_user
  belongs_to :study

  validates_presence_of :custom_user
  validates_presence_of :study
end