class SurveyImage
  include Mongoid::Document

  store_in collection: 'fs.files', database: 'omh'

  field :_id, type: Object

  field :filename, type: Object

  embeds_one :metadata

end