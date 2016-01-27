class AcquisitionProvenance
  #### Mongodb attributes
  include Mongoid::Document
  ###Location in the database
  store_in collection: 'dataPoint', database: 'omh'
  ### The atrributes you would like to call
  field :source_name, type: String
  field :modality, type: String
  ### Upper relation
  embedded_in :header, :inverse_of => :acquisition_provenance
end
