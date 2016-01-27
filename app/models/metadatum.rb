class Metadatum
  #### Mongodb attributes
  include Mongoid::Document

  store_in collection: 'fs.files', database: 'omh'

  embedded_in :survey_image, :inverse_of => :metadata

  field :media_id, type: String

  field :user_id, as: :pam_user_id, type: Object

end