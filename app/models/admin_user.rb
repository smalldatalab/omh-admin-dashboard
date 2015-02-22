class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_many :study_owners 
  has_many :studies, through: :study_owners

  has_many :users, through: :studies
  has_many :admin_surveys, through: :studies, class_name: 'Survey'
  has_many :admin_streams, through: :studies, class_name: 'DataStream'

  accepts_nested_attributes_for :studies
  
end
