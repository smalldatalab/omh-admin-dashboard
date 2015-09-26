class SurveyImage
  include Mongoid::GridFs

  # store_in collection: 'fs.files', database: 'omh'

  field :_id, type: Object
  field :filename, type: String

  embeds_one :metadata

end