class Home 
  include Mongoid::Document 
  store_in collection: 'dataPoint', database: 'omh'

  embedded_in :body

  field :latitude, type: Integer 
  field :longitude, type: Integer

  
end 