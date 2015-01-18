class AcquisitionProvenance 
  include Mongoid::Document

  store_in collection: 'dataPoint', database: 'omh'
  
  field :source_name, type: String
  field :modality, type: String 

  embedded_in :header, :inverse_of => :acquisition_provenance

  
end
