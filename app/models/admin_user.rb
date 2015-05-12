class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :study_owners
  has_many :studies, through: :study_owners

  has_many :users, through: :studies
  has_many :surveys, through: :studies
  has_many :data_streams, through: :studies

  accepts_nested_attributes_for :studies

  validates :email, presence: true
  validates :password, :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true
  validates :password, length: { minimum: 8 }

end
