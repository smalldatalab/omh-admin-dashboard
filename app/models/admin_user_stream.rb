class AdminUserStream < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :data_stream

  validates_presence_of :admin_user
  validates_presence_of :data_stream
end 