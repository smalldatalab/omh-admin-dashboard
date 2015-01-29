class User < ActiveRecord::Base 
	# use_connection_ninja(:sdl_admin_dashboard_development)
  # params.require(:user).permit(:study_name_ids => [])
# attr_accessible : studies_attributes  
  # attr_accessible :study_ids

  has_many :study_participants
  has_many :studies, through: :study_participants

  has_many :admin_users, through: :studies
  has_many :admin_users, through: :data_streams
  
  has_many :user_streams
  has_many :data_streams, through: :user_streams
  

  accepts_nested_attributes_for :studies
  accepts_nested_attributes_for :data_streams

  # accepts_nested_attributes_for :studies, :allow_destroy => true

  def user_record
    if PamUser.where('email_address' => {'address' => self.gmail}).blank? 
      return nil
    else 
      return PamUser.find_by('email_address' => {'address' => self.gmail})
    end 
  end

  def most_recent_pam_data_point
    pam_user = user_record

    if pam_user.nil? 
      return nil 
    else 
      if pam_user.pam_data_points.where('header.schema_id.name' => 'photographic-affect-meter-scores').last.nil? 
        return nil 
      else 
        pam_data =  pam_user.pam_data_points.where('header.schema_id.name' => 'photographic-affect-meter-scores').map! { |i| DateTime.parse(i.header.creation_date_time) }
        pam_data.sort.last.to_formatted_s(:long_ordinal)
      end
    end
	end

  def most_recent_mobility_data_point
    mobility_user = user_record
    if mobility_user.nil?
      return nil 
    else  
      if mobility_user.pam_data_points.where('header.schema_id.name' => 'mobility-stream-iOS').last.nil?
        nil
      else 
        mobility_data = mobility_user.pam_data_points.where('header.schema_id.name' => 'mobility-stream-iOS').map! { |i| DateTime.parse(i.header.creation_date_time) }
        mobility_data.sort.last.to_formatted_s(:long_ordinal)
      end
    end
  end
  
  def all_pam_data_points
    return user_record.pam_data_points.where('header.schema_id.name' => 'photographic-affect-meter-scores')
  end
  
  def all_mobility_data_points
    return user_record.pam_data_points.where('header.schema_id.name' => 'mobility-stream-iOS')
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
                data_point.body.affect_arousal,
                data_point.body.negative_affect,
                data_point.body.positive_affect,
                data_point.body.effective_time_frame.date_time,
                data_point.body.affect_valence,
                data_point.body.mood
               ] 
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

  def escape_nil_location(data, attribute)
    data.body.location.nil? ? nil : data.body.location.send(attribute)
  end

  def escape_nil_activities(data, attribute)
    data.body.activities.nil? ? nil : data.body.activities[0][attribute]
  end

end