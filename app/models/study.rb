class Study < ActiveRecord::Base
  has_many :admin_users, through: :study_owners
  has_many :study_owners

  has_many :organizations, through: :organization_studies
  has_many :organization_studies

  has_many :users, through: :study_participants
  has_many :study_participants

  has_many :s_data_streams
  has_many :data_streams, through: :s_data_streams

  has_many :s_surveys
  has_many :surveys, through: :s_surveys

  accepts_nested_attributes_for :data_streams
  accepts_nested_attributes_for :surveys

  # validates :data_streams, presence: true
  # validates :surveys, presence: true

end
