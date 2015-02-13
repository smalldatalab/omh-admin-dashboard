class DataStream < ActiveRecord::Base

  has_many :admin_user_streams
  has_many :admin_users, through: :admin_user_streams

  has_many :user_streams
  has_many :data_stream_users, through: :user_streams, class_name: 'User'

  # has_many :studies, through: :users
  # has_many :studies, through: :admin_users
  
end 