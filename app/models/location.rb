class Location
  #### Mongodb attributes
  include Mongoid::Document

  store_in collection: 'dataPoint', database: 'omh'

  field :speed, type: String
  field :longitude, type: String
  field :bearing, type: String
  field :latitude, type: String
  field :horizontal_accuracy, type: String
  field :vertical_accuracy, type: String
  field :altitude, type: String

  embedded_in :body, :inverse_of => :location

end
