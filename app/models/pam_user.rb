class PamUser
  include Mongoid::Document
  store_in collection: 'endUser', database: 'omh'

  field :_id, type: Object
  # field :_class, type: String
  # field :password_hash, type: Hash
  # field :registration_timestamp, type: Time

  has_many :pam_data_points

  # has_many :survey_images

  embeds_one :email_address


end