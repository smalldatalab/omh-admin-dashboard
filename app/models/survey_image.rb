class SurveyImage ## fs.files collection for storing media/images
  #### Mongodb attributes
  include Mongoid::Document
  store_in collection: 'fs.files', database: 'omh'

  field :_id, type: Object

  field :filename, type: Object

  embeds_one :metadata

end