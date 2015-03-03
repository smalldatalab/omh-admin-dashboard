class SDataStream < ActiveRecord::Base 
  belongs_to :data_stream
  belongs_to :study

  validates_presence_of :data_stream
  validates_presence_of :study
end 
