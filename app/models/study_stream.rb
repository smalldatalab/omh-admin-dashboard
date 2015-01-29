class StudyStream < ActiveRecord::Base 
  belongs_to :data_stream 
  belongs_to :study
end 
