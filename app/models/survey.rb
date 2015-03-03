class Survey < ActiveRecord::Base

  has_many :studies, through: :s_surveys
  has_many :s_surveys
  
  # has_many :survey_users, through: :studies, class_name: "User"
  # has_many :survey_admin_users, through: :studies, class_name: "AdminUser"
  
end 