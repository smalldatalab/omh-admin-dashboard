require 'json'

class CalendarDataPoint 

  # attr_accessor :users, :fullname, :givenname, :familyname, :daily

  def all_calendar_data_points
    file = File.read('data/data.json')
    data = JSON.parse(file)
  end  
  
  def get_calendar_data_url(u)
    u.all_calendar_data_points.to_json
  end 
end 