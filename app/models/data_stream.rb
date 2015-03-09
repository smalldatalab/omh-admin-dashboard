class DataStream < ActiveRecord::Base
  
  has_many :studies, through: :s_data_streams 
  has_many :s_data_streams

end 