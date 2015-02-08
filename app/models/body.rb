class Body
  include Mongoid::Document

  store_in collection: 'dataPoint', database: 'omh'

  embedded_in :pam_data_point, :inverse_of => :body
  
  field :activities, type: Array
  field :affect_arousal, type: Integer
  field :negative_affect, type: Integer
  field :positive_affect, type: Integer
  field :affect_valence, type: Integer
  field :mood, type: String

  embeds_one :location

  embeds_one :effective_time_frame

  embeds_one :data


end
