class Activity
  include Mongoid::Document 
  store_in collection: 'dataPoint', database: 'omh'
  
  field :activity, type: String
  field :confidence, type: String 
   
  embedded_in :body, :inverse_of => :activity

end 