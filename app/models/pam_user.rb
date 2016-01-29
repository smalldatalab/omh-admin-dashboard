class PamUser ## endUser collection
  #### Mongodb attributes
  include Mongoid::Document
  store_in collection: 'endUser', database: 'omh'

  field :_id, type: Object

  has_many :pam_data_points

  embeds_one :email_address


end