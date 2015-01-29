class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_many :study_owners 
  has_many :studies, through: :study_owners

  has_many :admin_user_streams
  has_many :data_streams, through: :admin_user_streams
  
  has_many :users, through: :studies
  has_many :users, through: :data_streams

  accepts_nested_attributes_for :studies
  accepts_nested_attributes_for :data_streams
end
