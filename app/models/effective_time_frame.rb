class EffectiveTimeFrame
  include Mongoid::Document

  store_in collection: 'dataPoint', database: 'omh'
  
  field :date_time, type: String

  embedded_in :body
  # , :inverse_of => :effective_time_frame

end