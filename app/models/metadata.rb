class Metadata
  include Mongoid::Document

  store_in collection: 'fs.files', database: 'omh'

  field :media_id, type: String

  embedded_in :survey_image, :inverse_of => :metadata

end