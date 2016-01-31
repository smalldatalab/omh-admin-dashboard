class EmailAddress
  #### Mongodb attributes
  include Mongoid::Document
  store_in collection: 'endUser', database: 'omh'

  field :address, type: String

  embedded_in :pam_user, :inverse_of => :email_address

end
