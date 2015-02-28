class Version 
  include Mongoid::Document 

  store_in collection: 'dataPoint', database: 'omh'
  
  field :major, type: Float
  field :minor, type: Float 
  
  embedded_in :schema_id, :inverse_of => :version

end 