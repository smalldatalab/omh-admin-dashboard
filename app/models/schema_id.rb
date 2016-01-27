class SchemaId
  #### Mongodb attributes
  include Mongoid::Document
  store_in collection: 'dataPoint', database: 'omh'
  field :namespace, type: String
  field :name, type: String

  embedded_in :header, :inverse_of => :schema_id
  embeds_one :version

end
