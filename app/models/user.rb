class User < ActiveRecord::Base
  has_many :study_participants
  has_many :studies, through: :study_participants

  has_many :admin_users, through: :studies

  has_many :surveys, through: :studies
  has_many :data_streams, through: :studies


  accepts_nested_attributes_for :studies

  validates :studies, presence: true
  # validates_format_of :username, without: /\s/, message: "can't have space"
  validates_uniqueness_of :username

  # validates_acceptance_of :gmail, message: "This gmail address doesn't have any data points", :if => Proc.new { |user| user.gmail.nil? ? nil : PamUser.where('email_address' => {'address' => user.gmail.gsub(/\s+/, "").downcase}).blank? }
  def registrated_in_database
    # gmail = self.gmail.gsub(/\s+/, "").downcase
    user_name = self.username
    if PamUser.where('_id' => user_name).blank?
      return "No"
    else
      return "Yes"
    end
  end

  def user_record
    user_name = self.username
    if PamUser.where('_id' => user_name).blank?
      return nil
    else
      return PamUser.find_by('_id' => user_name)
    end
  end

  def most_recent_data_point_date(data_stream, device=nil)
    if user_record.nil?
      return ''
    else
      recent_data_point = user_record.pam_data_points.where('header.schema_id.name' => data_stream, 'body.device' => device)
      if recent_data_point.last.nil?
        return ''
      else
        DateTime.parse(recent_data_point.order('header.creation_date_time_epoch_milli DESC').limit(1).first.header.creation_date_time).to_formatted_s(:long_ordinal)
      end
    end
  end


  def most_recent_ohmage_data_point_date(admin_user_id)
    if user_record.nil?
      return ''
    else
      ohmage_data_points = user_record.pam_data_points.where('header.acquisition_provenance.source_name' => /^Ohmage/)
      if ohmage_data_points.last.nil?
        return ''
      else
        if AdminUser.find(admin_user_id).researcher?
          admin_surveys = []
          AdminUser.find(admin_user_id).surveys.each do |a|
            admin_surveys.push(a.search_key_name)
          end
          admin_ohmage_data_points = ohmage_data_points.where('header.schema_id.name' => { '$in' => admin_surveys})
          if admin_ohmage_data_points.blank?
            return ''
          else
            DateTime.parse(admin_ohmage_data_points.order('header.creation_date_time_epoch_milli DESC').limit(1).first.header.creation_date_time).to_formatted_s(:long_ordinal)
          end
        else
          DateTime.parse(ohmage_data_points.order('header.creation_date_time_epoch_milli DESC').limit(1).first.header.creation_date_time).to_formatted_s(:long_ordinal)
        end
      end
    end
  end

  def one_day_pam_data_points(date)
    if user_record.nil?
      return nil
    else
      pam_data_points = user_record.pam_data_points.where('header.schema_id.name' => 'photographic-affect-meter-scores')
      if pam_data_points.last.nil?
        return nil
      else
        pam_data_points.where('header.creation_date_time' => date)
      end
    end
  end

  def one_day_fitbit_data_points(date)
    if user_record.nil?
      return nil
    else
      fitbit_data_points = user_record.pam_data_points.where('header.schema_id.name' => 'step_count', 'header.schema_id.namespace' => 'omh')
      if fitbit_data_points.last.nil?
        return nil
      else
        fitbit_data_points.where('header.creation_date_time' => date)
      end
    end
  end

  def one_day_ohmage_data_points(admin_user_id, date)
    if user_record.nil?
      return nil
    else
      ohmage_data_points = user_record.pam_data_points.where('header.acquisition_provenance.source_name' => /^Ohmage/, 'header.creation_date_time' => date)
      if ohmage_data_points.last.nil?
        return nil
      else
        if AdminUser.find(admin_user_id).researcher?
          admin_surveys = []
          AdminUser.find(admin_user_id).surveys.each do |a|
            admin_surveys.push(a.search_key_name)
          end
          ohmage_data_points.where('header.schema_id.name' => { '$in' => admin_surveys})
        else
          ohmage_data_points
        end
      end
    end
  end


  def calendar_pam_events_array
    pam_events_array = []
    pam_events_date = []

    if  all_pam_data_points.nil?
      return nil
    else
      all_pam_data_points.each do |pam_data|
        pam_events_date << pam_data.header.creation_date_time[0..9]
        pam_events_date = pam_events_date.uniq
      end
    end

    pam_events_date.each do |pam_date|
      pam_events_array.push({
        title: 'PAM',
        start: pam_date,
        className: 'event_style'
      })
    end
    return pam_events_array.to_json
  end

  def calendar_fitbit_events_array
    fitbit_events_array = []
    fitbit_events_date = []

    if all_fitbit_data_points.nil?
      return nil
    else
      all_fitbit_data_points.each do |fitbit_data|
        fitbit_events_date << fitbit_data.header.creation_date_time[0..9]
        fitbit_events_date = fitbit_events_date.uniq
      end
    end

    fitbit_events_date.each do |fitbit_date|
      fitbit_events_array.push({
        title: 'Fitbit',
        start: fitbit_date,
        className: 'event_style'

      })
    end
    return fitbit_events_array.to_json
  end

  def calendar_ohmage_events_array(admin_user_id)
    ohmage_events_array = []
    ohamge_events_date = []

    if all_ohmage_data_points(admin_user_id).nil?
      return nil
    else
      all_ohmage_data_points(admin_user_id).each do |ohmage_data|
        ohamge_events_date << ohmage_data.header.creation_date_time[0..9]
        ohamge_events_date = ohamge_events_date.uniq
      end
    end

    ohamge_events_date.each do |ohmage_date|
      ohmage_events_array << {
        title: 'ohmage',
        start: ohmage_date,
        className: 'event_style'
      }
    end
    return ohmage_events_array.to_json
  end


  def all_pam_data_points
    if user_record.nil?
      return nil
    else
      pam_data_points = user_record.pam_data_points.where('header.schema_id.name' => 'photographic-affect-meter-scores')
      if pam_data_points.last.nil?
        return nil
      else
        return pam_data_points
      end
    end
  end

  def all_mobility_data_points
    if user_record.nil?
      return nil
    else
      mobility_data_points = user_record.pam_data_points.where('header.schema_id.name' => 'mobility-daily-summary')
      if mobility_data_points.last.nil?
        return nil
      else
        mobility_data_points
      end
    end
  end

  def all_ohmage_data_points(admin_user_id)
    if user_record.nil?
      return nil
    else
      ohmage_data_points = user_record.pam_data_points.where('header.acquisition_provenance.source_name' => /^Ohmage/)
      if ohmage_data_points.last.nil?
        return nil
      else
        if AdminUser.find(admin_user_id).researcher?
          admin_surveys = []
          AdminUser.find(admin_user_id).surveys.each do |a|
            admin_surveys.push(a.search_key_name)
          end
          ohmage_data_points.where('header.schema_id.name' => { '$in' => admin_surveys})
        else
          ohmage_data_points
        end
      end
    end
  end

  def all_calendar_data_points
    if user_record.nil?
      return nil
    else
      mobility_data_points = user_record.pam_data_points.where('header.schema_id.name' => 'mobility-daily-summary')
      if mobility_data_points.last.nil?
        return nil
      else
        if mobility_data_points.where('body.device' => 'ios').last.nil?
          if mobility_data_points.where('body.device' => 'android').last.nil?
            mobility_data_points.where('body.device' => 'moves-app')
          else
            mobility_data_points.where('body.device' => 'android')
          end
        else
          mobility_data_points.where('body.device' => 'ios')
        end
      end
    end
  end


  def all_fitbit_data_points
    if user_record.nil?
      return nil
    else
      fitbit_data_points = user_record.pam_data_points.where('header.schema_id.name' => 'step_count', 'header.schema_id.namespace' => 'omh')
      if fitbit_data_points.last.nil?
        return nil
      else
        fitbit_data_points
      end
    end
  end

  # def multi_users_data(ids)
  #   User.find(ids).each do |user|
  #     pam_csv = user.pam_data_csv
  #     fjlkdsjfj
  #   end
  # end




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

  def get_all_survey_question_keys(admin_user_id)
    ohmage_data_points = all_ohmage_data_points(admin_user_id)
    if user_record.nil?
      return nil
    else
      if ohmage_data_points.nil?
        return nil
      else
        survey_keys = [
                      'id',
                      'user_id',
                      'creation_date_time',
                      'survey_namespace',
                      'survey_name',
                      'survey_version'
                      ]
        ohmage_data_points.each do |a|
          if a.body.data
            a.body.data.attributes.each do |key, value|
              survey_keys.push(key) unless survey_keys.include? key
            end
          end
        end
        return survey_keys
      end
    end
  end

  def get_all_survey_question_values(survey_keys, data_point)
    survey_values = [
                    data_point._id,
                    data_point.user_id,
                    data_point.header.creation_date_time,
                    data_point.header.schema_id.namespace,
                    data_point.header.schema_id.name,
                    data_point.header.schema_id.version.major.to_s + '.' + data_point.header.schema_id.version.minor.to_s
                    ]
    fixed_survey_values_count = survey_values.length
    if data_point.body.data
      survey_keys.each_with_index do |key, index|
        if index >= fixed_survey_values_count
          survey_values << data_point.body.data[key] ? data_point.body.data[key] : nil
        end
      end
    end
    return survey_values
  end


  def ohmage_data_csv(admin_user_id=nil)
    CSV.generate do |csv|
      keys = get_all_survey_question_keys(admin_user_id)

      if keys
        csv << keys
        data_points = all_ohmage_data_points(admin_user_id)

        if data_points.nil?
          return nil
        else
          data_points.each do |data_point|
            csv << get_all_survey_question_values(keys, data_point) if data_point.body.data
          end
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
              'active time in minutes',
              'walking distance in km',
              'steps',
              'geodiameter in km',
              'max gait speed in meter per second',
              'leaving home time',
              'return home time',
              'time not at home in minutes',
              'coverage'
             ]
      if all_mobility_data_points.nil?
        return nil
      else
        all_mobility_data_points.each do |data_point|
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
                  escape_nil_body(data_point, :active_time_in_seconds).nil? ? nil : (data_point.body.active_time_in_seconds / 60.00),
                  escape_nil_body(data_point, :walking_distance_in_km),
                  escape_nil_body(data_point, :steps),
                  escape_nil_body(data_point, :geodiameter_in_km),
                  escape_nil_body(data_point, :max_gait_speed_in_meter_per_second),
                  escape_nil_body(data_point, :leave_home_time),
                  escape_nil_body(data_point, :return_home_time),
                  escape_nil_body(data_point, :time_not_at_home_in_seconds).nil? ? nil : (data_point.body.time_not_at_home_in_seconds / 60.00),
                  escape_nil_body(data_point, :coverage)
                  ]
        end
      end
    end
  end

  def fitbit_data_csv
    CSV.generate do |csv|
      csv << [
              'id',
              'user_id',
              'date',
              'steps'
      ]
      if all_fitbit_data_points.nil?
        return nil
      else
        all_fitbit_data_points.each do |data_point|
        csv << [
                 data_point._id,
                 data_point.user_id,
                 data_point.header.creation_date_time,
                 data_point.body.step_count
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
          max_gait_speed_in_meter_per_second: escape_and_round(data_point.body.max_gait_speed_in_meter_per_second),
          active_time_in_seconds: (escape_and_round(data_point.body.active_time_in_seconds) / 60),
          time_not_at_home_in_seconds:  (escape_and_round(data_point.body.time_not_at_home_in_seconds) / 60)
        }
      end
    end
    return JSON.parse(json_data.to_json)
  end

  def escape_and_round(data)
    data ? data.round : 0
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