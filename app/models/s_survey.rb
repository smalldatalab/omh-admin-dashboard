class SSurvey < ActiveRecord::Base
  belongs_to :survey
  belongs_to :study


  validates_presence_of :survey
  validates_presence_of :study
end 