class Survey < ActiveRecord::Base

  has_many :studies, through: :s_surveys
  has_many :s_surveys
  
end 