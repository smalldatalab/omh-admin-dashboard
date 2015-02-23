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

# For the mobility daily summary data points 
  field :date, type: String
  field :device, type: String
  field :active_time_in_seconds, type: Integer
  field :walking_distance_in_km, type: Integer
  field :geodiameter_in_km, type: Integer
  field :leave_home_time, type: Integer
  field :return_home_time, type: Integer
  field :coverage, type: Integer
  field :max_gait_speed_in_meter_per_second, type: Integer
  field :time_not_at_home_in_seconds, type: Integer

  embeds_one :location

  embeds_one :effective_time_frame

  embeds_one :data

  embeds_one :home


end
