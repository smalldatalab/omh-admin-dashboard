class Version
  include Mongoid::Document

  store_in collection: 'dataPoint', database: 'omh'

  field :major, type: Integer
  field :minor, type: Integer

  embedded_in :schema_id, :inverse_of => :version

end