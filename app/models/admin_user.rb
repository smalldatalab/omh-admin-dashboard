class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_many :study_owners 
  has_many :studies, through: :study_owners
  has_many :users, through: :studies

  accepts_nested_attributes_for :studies
end
