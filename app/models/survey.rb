class Survey < ActiveRecord::Base

  has_many :studies, through: :study_surveys
  has_many :study_surveys
  
  has_many :survey_users, through: :studies, class_name: 'User'
  
end 