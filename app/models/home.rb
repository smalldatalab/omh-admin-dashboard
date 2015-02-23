class Home 
  include Mongoid::Document 
  store_in collection: 'dataPoint', database: 'omh'

  embedded_in :body, :inverse_of => :home

  field :latitude, type: Integer 
  field :longtitude, type: Integer

  
end 