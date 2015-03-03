class DataStream < ActiveRecord::Base
  
  has_many :studies, through: :s_data_streams 
  has_many :s_data_streams

  # has_many :stream_admin_users, through: :studies. class_name: "AdminUser"
  # has_many :stream_users, through: :studies, class_name: "User"
  

end 