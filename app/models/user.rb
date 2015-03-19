class User < ActiveRecord::Base 
  
  
  has_many :study_participants
  has_many :studies, through: :study_participants

  has_many :admin_users, through: :studies
  
  has_many :surveys, through: :studies 
  has_many :data_streams, through: :studies
  

  accepts_nested_attributes_for :studies
  
  validates :studies, :gmail, presence: true

  def user_record
    if PamUser.where('email_address' => {'address' => self.gmail}).blank? 
      return nil
    else 
      return PamUser.find_by('email_address' => {'address' => self.gmail})
    end 
  end

  def most_recent_data_point_date(data_stream)
    if user_record.nil? 
      return ''
    else  
      if user_record.pam_data_points.where('header.schema_id.name' => data_stream).last.nil? 
        return '' 
      else 
        DateTime.parse(user_record.pam_data_points.where('header.schema_id.name' => data_stream).order('header.creation_date_time_epoch_milli DESC').limit(1).first.header.creation_date_time).to_formatted_s(:long_ordinal)
      end 
    end
  end 

  def all_pam_data_points
    if user_record.nil? 
      return nil 
    else 
      if user_record.pam_data_points.where('header.schema_id.name' => 'photographic-affect-meter-scores').last.nil? 
        return nil 
      else 
        user_record.pam_data_points.where('header.schema_id.name' => 'photographic-affect-meter-scores')
      end
    end
  end 

  def all_mobility_data_points
    if user_record.nil? 
      return nil 
    else 
      if user_record.pam_data_points.where('header.schema_id.name' => 'mobility-stream-iOS').last.nil? 
        return nil 
      else 
        user_record.pam_data_points.where('header.schema_id.name' => 'mobility-stream-iOS')
      end
    end
  end 

  def all_ohmage_data_points
    if user_record.nil? 
      return nil 
    else 
      if user_record.pam_data_points.where('header.acquisition_provenance.source_name' => /^Ohmage/).last.nil? 
        return nil 
      else 
        user_record.pam_data_points.where('header.acquisition_provenance.source_name' => /^Ohmage/)
      end
    end
  end 

  def all_calendar_data_points
    if user_record.nil? 
      return nil 
    else 
      if user_record.pam_data_points.where('header.schema_id.name' => 'mobility-daily-summary').last.nil? 
        return nil 
      else 
        user_record.pam_data_points.where('header.schema_id.name' => 'mobility-daily-summary')
      end
    end
  end 
  

  def pam_data_csv
    CSV.generate do |csv|
      csv << [
              'id',
              'class',
              'user id', 
              'name space',
              'name', 
              'version major', 
              'version minor', 
              'creation date time', 
              'source name',
              'modality',
              'affect arousal',
              'negative affect',
              'positive affect',
              'effective time frame date time', 
              'affect valence',
              'mood'
             ]
        if all_pam_data_points.nil?
          return nil
        else  
          all_pam_data_points.each do |data_point|
            csv << [
                  data_point._id,
                  data_point._class,
                  data_point.user_id, 
                  data_point.header.schema_id.namespace,
                  data_point.header.schema_id.name,
                  data_point.header.schema_id.version.major,
                  data_point.header.schema_id.version.minor,
                  data_point.header.creation_date_time,
                  data_point.header.acquisition_provenance.source_name,
                  data_point.header.acquisition_provenance.modality,
                  escape_nil_body(data_point, :affect_arousal),
                  escape_nil_body(data_point, :negative_affect),
                  escape_nil_body(data_point, :positive_affect),
                  data_point.body.effective_time_frame.nil? ? nil : data_point.body.effective_time_frame.date_time,
                  escape_nil_body(data_point, :affect_valence),
                  escape_nil_body(data_point, :mood)
                 ] 
        
          end
        end
    end
  end

  def mobility_data_csv
    CSV.generate do |csv|
      csv << [
              'id',
              'class',
              'user id', 
              'name space',
              'name', 
              'version major', 
              'version minor', 
              'creation date time', 
              'source name',
              'modality',
              'activity',
              'confidence',
              'speed',
              'longitude', 
              'bearing',
              'latitude',
              'horizontal accuracy',
              'vertical accuracy', 
              'altitude' 
             ]
      if all_mobility_data_points.nil?
        return nil 
      else 
        all_mobility_data_points.each do |data_point|
          csv << [
                data_point._id,
                data_point._class,
                data_point.user_id, 
                data_point.header.schema_id.namespace,
                data_point.header.schema_id.name,
                data_point.header.schema_id.version.major,
                data_point.header.schema_id.version.minor,
                data_point.header.creation_date_time,
                data_point.header.acquisition_provenance.source_name,
                data_point.header.acquisition_provenance.modality,
                escape_nil_activities(data_point, 'activity'),
                escape_nil_activities(data_point, 'confidence'),
                escape_nil_location(data_point, :speed),
                escape_nil_location(data_point, :longitude), 
                escape_nil_location(data_point, :bearing),
                escape_nil_location(data_point, :latitude), 
                escape_nil_location(data_point, :horizontal_accuracy), 
                escape_nil_location(data_point, :vertical_accuracy),
                escape_nil_location(data_point, :altitude)
               ] 
        end
      end
    end
  end

  def ohmage_data_csv
    CSV.generate do |csv|
      csv << [
              'id',
              'class',
              'user id', 
              'name space',
              'name', 
              'version major', 
              'version minor', 
              'creation date time', 
              'source name',
              'modality',
              'rise from sitting',
              'twist pivot',
              'knee pain severity',
              'bed', 
              'bending',
              'kneeling',
              'socks',
              'squatting'
             ]
      if all_ohmage_data_points.nil?
        return nil 
      else 
        all_ohmage_data_points.each do |data_point|
          csv << [
                  data_point._id,
                  data_point._class,
                  data_point.user_id, 
                  data_point.header.schema_id.namespace,
                  data_point.header.schema_id.name,
                  data_point.header.schema_id.version.major,
                  data_point.header.schema_id.version.minor,
                  data_point.header.creation_date_time,
                  data_point.header.acquisition_provenance.source_name,
                  data_point.header.acquisition_provenance.modality,
                  escape_nil_data(data_point, :RisefromSitting),
                  escape_nil_data(data_point, :TwistPivot),
                  escape_nil_data(data_point, :KneePainSeverity),
                  escape_nil_data(data_point, :Bed),
                  escape_nil_data(data_point, :Bending),
                  escape_nil_data(data_point, :Kneeling),
                  escape_nil_data(data_point, :Socks), 
                  escape_nil_data(data_point, :Squatting)
                 ] 
        end
      end
    end
  end

  def mobility_daily_summary_data_csv
     CSV.generate do |csv|
      csv << [
              'id',
              'user id',
              'class',
              'namespace', 
              'name',
              'version major',
              'version minor',
              'creation date time', 
              'creation date time epoch milli', 
              'source_name', 
              'modality',
              'date', 
              'device',
              'active time in seconds',
              'walking distance in km', 
              'geodiameter in km',
              'max gait speed in meter per second', 
              'leaving home time',
              'return home time', 
              'time not at home in seconds',
              'coverage'
             ]
      if all_calendar_data_points.nil?
        return nil 
      else 
        all_calendar_data_points.each do |data_point|
          csv << [
                  data_point._id,
                  data_point.user_id, 
                  data_point._class,
                  data_point.header.schema_id.namespace,
                  data_point.header.schema_id.name,
                  data_point.header.schema_id.version.major,
                  data_point.header.schema_id.version.minor,
                  data_point.header.creation_date_time,
                  data_point.header.creation_date_time_epoch_milli, 
                  data_point.header.acquisition_provenance.source_name,
                  data_point.header.acquisition_provenance.modality,
                  escape_nil_body(data_point, :date),
                  escape_nil_body(data_point, :device),
                  escape_nil_body(data_point, :active_time_in_seconds),
                  escape_nil_body(data_point, :walking_distance_in_km), 
                  escape_nil_body(data_point, :geodiameter_in_km), 
                  escape_nil_body(data_point, :max_gait_speed_in_meter_per_second),
                  escape_nil_body(data_point, :leave_home_time),
                  escape_nil_body(data_point, :return_home_time), 
                  escape_nil_body(data_point, :time_not_at_home_in_seconds),
                  escape_nil_body(data_point, :coverage)
                  ] 
        end
      end
    end
  end 


  def calendar_data_json 
    json_data = { 
                  users: {
                    c6651b99_8f9c_4d83_8f4b_8c02a00ddf9c: {
                      fullname: "",
                        givenname: "",
                        familyname: "",
                        daily: {}
                    }                  
                  }
                }
    if all_calendar_data_points.nil? 
      return nil 
    else 
      all_calendar_data_points.each do |data_point| 
        json_data[:users][:c6651b99_8f9c_4d83_8f4b_8c02a00ddf9c][:daily][data_point.body.date + 'T00:00:00.000Z'] = {
          max_gait_speed_in_meter_per_second:  data_point.body.max_gait_speed_in_meter_per_second.ceil,
          active_time_in_seconds: data_point.body.active_time_in_seconds,
          time_not_at_home_in_seconds:  data_point.body.time_not_at_home_in_seconds
          
        }   
      end
    end
    return JSON.parse(json_data.to_json)
  end  

  def escape_nil_location(data, attribute)
    data.body.location.nil? ? nil : data.body.location.send(attribute)
  end
  
  def escape_nil_home(data, attribute)
    data.body.home.nil? ? nil : data.body.home.send(attribute)
  end 

  def escape_nil_activities(data, attribute)
    data.body.activities.nil? ? nil : data.body.activities[0][attribute]
  end

  def escape_nil_data(data, attribute)
    data.body.data.nil? ? nil : data.body.data.send(attribute)
  end 

  def escape_nil_body(data, attribute)
    data.body.nil? ? nil : data.body.send(attribute)
  end 
end