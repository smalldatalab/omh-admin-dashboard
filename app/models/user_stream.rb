class UserStream < ActiveRecord::Base
  belongs_to :user
  belongs_to :data_stream

  validates_presence_of :user
  validates_presence_of :data_stream
end 
