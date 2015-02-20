class DataStream < ActiveRecord::Base
  
  has_many :studies, through: :study_streams 
  has_many :study_streams

  has_many :stream_users, through: :studies, class_name: 'User'


  
end 