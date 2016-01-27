class PamDataPoint ### dataPoint collection
  #### Mongodb attributes
  include Mongoid::Document

  store_in collection: 'dataPoint', database: 'omh'

  field :_id, type: Object
  field :_class, type: Object
  field :user_id, as: :pam_user_id, type: Object


  belongs_to :pam_user

  embeds_one :header

  embeds_one :body

end
