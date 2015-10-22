class SurveyImage
  include Mongoid::Document

  store_in collection: 'fs.files', database: 'omh'

  field :_id, type: Object

  belongs_to :pam_user

  embeds_one :metadata


end