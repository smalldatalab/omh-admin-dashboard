class Body
  include Mongoid::Document

  store_in collection: 'dataPoint', database: 'omh'

  embedded_in :pam_data_point, :inverse_of => :body

  field :activities, type: Array
  field :affect_arousal, type: Float
  field :negative_affect, type: Float
  field :positive_affect, type: Float
  field :affect_valence, type: Float
  field :mood, type: String

# For the mobility daily summary data points
  field :date, type: String
  field :device, type: String
  field :active_time_in_seconds, type: Float
  field :walking_distance_in_km, type: Float
  field :geodiameter_in_km, type: Float
  field :leave_home_time, type: Float
  field :return_home_time, type: Float
  field :coverage, type: Float
  field :max_gait_speed_in_meter_per_second, type: Float
  field :time_not_at_home_in_seconds, type: Float
  field :steps, type: Float

# For Fitbit
  field :step_count, type: Integer

# For LogIn
  field :level, type: String
  field :event, type: String
  field :msg, type: String

  embeds_one :location

  embeds_one :effective_time_frame

  embeds_one :data

  embeds_one :home


end
