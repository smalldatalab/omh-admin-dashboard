class PamUser
  include Mongoid::Document
  store_in collection: 'endUser', database: 'omh'

  field :_id, type: Object

  # embeds_one :email_address
  has_many :pam_data_points

  embeds_one :email_address
   

  

 
end