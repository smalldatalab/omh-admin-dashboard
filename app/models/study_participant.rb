class StudyParticipant < ActiveRecord::Base
  belongs_to :study	
  belongs_to :user

  validates_presence_of :study
  validates_presence_of :user
  
end
