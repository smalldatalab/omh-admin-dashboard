class Datum
  include Mongoid::Document

  store_in collection: 'dataPoint', database: 'omh'

  embedded_in :body, :inverse_of => :data
  
  field :RisefromSitting, type: String
  field :TwistPivot, type: String
  field :KneePainSeverity, type: Float
  field :Bed, type: String
  field :Bending, type: String
  field :Kneeling, type: String
  field :Socks, type: String
  field :Squatting, type: String

end 