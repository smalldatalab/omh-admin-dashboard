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

  field :date, type: String
  field :active_time_in_seconds, type: Integer
  field :max_gait_speed_in_meter_per_second, type: Integer
  field :time_not_at_home_in_seconds, type: Integer

  embeds_one :location

  embeds_one :effective_time_frame

  embeds_one :data


end
