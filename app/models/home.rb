class Home
  #### Mongodb attributes
  include Mongoid::Document
  store_in collection: 'dataPoint', database: 'omh'

  embedded_in :body

  field :latitude, type: Integer
  field :longitude, type: Integer

  field :return_home_time, type: DateTime
  field :leave_home_time, type: DateTime

end