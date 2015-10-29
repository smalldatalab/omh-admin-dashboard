class SurveyImage
  include Mongoid::Document
  # include MongoMapper::Document

  store_in collection: 'fs.files', database: 'omh'

  field :_id, type: Object

  # field :filename, type: Object

  belongs_to :pam_user

  embeds_one :metadata


end