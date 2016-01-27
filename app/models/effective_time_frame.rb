class EffectiveTimeFrame
  #### Mongodb attributes
  include Mongoid::Document
  store_in collection: 'dataPoint', database: 'omh'

  field :date_time, type: String

  embedded_in :body
end