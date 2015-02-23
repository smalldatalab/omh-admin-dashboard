class Header
  include Mongoid::Document

  store_in collection: 'dataPoint', database: 'omh'

  field :_id, type: String
  field :creation_date_time, type: String
  field :creation_date_time_epoch_milli, type: String

  embedded_in :pam_data_point, :inverse_of => :header

  embeds_one :schema_id
  embeds_one :acquisition_provenance
  
end
