class User < ActiveRecord::Base
  has_many :study_participants
  has_many :studies, through: :study_participants
  # has_many :admin_users, through: :studies

  has_many :surveys, through: :studies
  has_many :data_streams, through: :studies
  # has_many :organizations, through: :studies

  has_many :annotations

  accepts_nested_attributes_for :studies
  validates :studies, presence: true
  validates_uniqueness_of :username

  after_find :init

  ### Search participant in the endUser collection in the mongodb using username attribute
  def init
    user_name = self.username
    pam_user = PamUser.where('_id' => user_name).first
    @user_record = pam_user.nil? ? nil : pam_user
  end

  #### Check whehter the participant is registered
  def registrated_in_database
    @user_record.nil? ? "No" : "Yes"
  end

  #### Get most recent uploaded date for all data and render it on Participant's Index
  def most_recent_data_point_date(data_stream, device=nil)
    if !@user_record.nil?
      recent_data_point = @user_record.pam_data_points.where('header.schema_id.name' => data_stream, 'body.device' => device).order('header.creation_date_time_epoch_milli DESC').limit(1).first
      if !recent_data_point.blank?
        DateTime.parse(recent_data_point.header.creation_date_time).to_formatted_s(:long_ordinal)
      end
    end
  end

  def most_recent_mobility_data_point_date
    if !@user_record.nil?
      recent_data_point = @user_record.pam_data_points.where('header.schema_id.name' => 'mobility-daily-summary', 'body.device' => {'$in' => ['ios', 'android', 'iOS', 'Android']}).order('header.creation_date_time_epoch_milli DESC').limit(1).first
      if !recent_data_point.blank?
        DateTime.parse(recent_data_point.header.creation_date_time).to_formatted_s(:long_ordinal)
      end
    end
  end


  def most_recent_ohmage_data_point_date(admin_user_id)
    if !@user_record.nil?
      ohmage_data_points = @user_record.pam_data_points.where('header.acquisition_provenance.source_name' => /^Ohmage/,'header.acquisition_provenance.modality' => 'SELF_REPORTED').order('header.creation_date_time_epoch_milli DESC')
      if !ohmage_data_points.blank?
        if AdminUser.find(admin_user_id).researcher?
          admin_surveys = []
          AdminUser.find(admin_user_id).surveys.each do |a|
            admin_surveys.push(a.search_key_name)
          end
          admin_ohmage_data_points = ohmage_data_points.where('header.schema_id.name' => { '$in' => admin_surveys}).order('header.creation_date_time_epoch_milli DESC').limit(1).first
          if !admin_ohmage_data_points.blank?
            DateTime.parse(admin_ohmage_data_points.header.creation_date_time).to_formatted_s(:long_ordinal)
          end
        else
          DateTime.parse(ohmage_data_points.limit(1).first.header.creation_date_time).to_formatted_s(:long_ordinal)
        end
      end
    end
  end

  ##### Get one day data
  def one_day_pam_data_points(date)
    if !@user_record.blank?
      pam_data_points = @user_record.pam_data_points.where('header.schema_id.name' => 'photographic-affect-meter-scores')
      if !pam_data_points.blank?
        pam_data_points.where('header.creation_date_time' => date)
      end
    end
  end

  def one_day_fitbit_data_points(date)
    if !@user_record.blank?
      fitbit_data_points = @user_record.pam_data_points.where('header.schema_id.name' => 'step-count', 'header.schema_id.namespace' => 'omh')
      if !fitbit_data_points.blank?
        fitbit_data_points.where('header.creation_date_time' => date)
      end
    end
  end

  def one_day_ohmage_data_points(admin_user_id, date)
    if !@user_record.nil?
      ohmage_data_points = @user_record.pam_data_points.where('header.acquisition_provenance.source_name' => /^Ohmage/,'header.acquisition_provenance.modality' => 'SELF_REPORTED', 'header.creation_date_time' => date)
      if !ohmage_data_points.last.nil?
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

  ### Get arrays of data to render on the calendar
  def calendar_pam_events_array
    pam_events_array = []
    pam_events_date = []

    if !all_pam_data_points.blank?
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

    if !all_fitbit_data_points.blank?
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

  def calendar_annotation_events_array
    annotations_array = []

    if !self.annotations.blank?
     self.annotations.all.each do |anno|
        annotations_array.push({
          title: anno.title,
          start: anno.start,
          color: '#d9534f',
          textColor: 'white'
          })
      end
    end
    return annotations_array.to_json
  end


  def calendar_ohmage_events_array(admin_user_id)
    ohmage_events_array = []
    ohamge_events_date = []

    if !all_ohmage_data_points(admin_user_id).blank?
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

  ##### Get all data
  def all_pam_data_points
    if !@user_record.nil?
      pam_data_points = @user_record.pam_data_points.where('header.schema_id.name' => 'photographic-affect-meter-scores').order('header.creation_date_time_epoch_milli DESC')
      if !pam_data_points.blank?
        pam_data_points
      end
    end
  end

  def all_mobility_data_points
    if !@user_record.nil?
      mobility_data_points = @user_record.pam_data_points.where('header.schema_id.name' => 'mobility-daily-summary').without('body.episodes').order('header.creation_date_time_epoch_milli DESC')
      if !mobility_data_points.blank?
        mobility_data_points
      end
    end
  end

  def all_ohmage_data_points(admin_user_id)
    if !@user_record.nil?
      ohmage_data_points = @user_record.pam_data_points.where('header.acquisition_provenance.source_name' => /^Ohmage/, 'header.acquisition_provenance.modality' => 'SELF_REPORTED').order('header.creation_date_time_epoch_milli DESC')
      if !ohmage_data_points.blank?
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
    if !@user_record.nil?
      mobility_data_points = @user_record.pam_data_points.where('header.schema_id.name' => 'mobility-daily-summary')
      if !mobility_data_points.blank?
        if mobility_data_points.where('body.device' => 'moves-app').last.nil?
          if mobility_data_points.where('body.device' => 'ios').last.nil?
            mobility_data_points.where('body.device' => 'android')
          else
            mobility_data_points.where('body.device' => 'ios')
          end
        else
          mobility_data_points.where('body.device' => 'moves-app')
        end
      end
    end
  end


  def all_fitbit_data_points
    if !@user_record.nil?
      fitbit_data_points = @user_record.pam_data_points.where('header.schema_id.name' => 'step-count', 'header.schema_id.namespace' => 'omh').order('header.creation_date_time_epoch_milli DESC')
      logger.debug "Number of fitbit records: #{fitbit_data_points.size}"
      if !fitbit_data_points.blank?
        fitbit_data_points
      end
    end
  end


  def all_log_in_data_points
    if !@user_record.nil?
      log_in_data_points = @user_record.pam_data_points.where('header.schema_id.name' => 'app-log').order('header.creation_date_time_epoch_milli DESC')
      if !log_in_data_points.blank?
        log_in_data_points
      end
    end
  end


  ##### For all CSV data download functions
  def pam_data_csv
    CSV.generate do |csv|
      csv << [
              'class',
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
        if !all_pam_data_points.blank?
          all_pam_data_points.each do |data_point|
            csv << [
                  data_point._class,
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
    if !@user_record.nil?
      if !ohmage_data_points.blank?
        survey_keys = [
                      'source_name',
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
          else
             a.body.attributes.each do |key, value|
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
                    data_point.header.acquisition_provenance.source_name,
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
    else
      survey_keys.each_with_index do |key, index|
        if index >= fixed_survey_values_count
          survey_values << data_point.body[key] ? data_point.body[key] : nil
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
        if !data_points.blank?
          data_points.each do |data_point|
            csv << get_all_survey_question_values(keys, data_point) if data_point.body.data || data_point.body
          end
        end
      end
    end
  end


  def mobility_daily_summary_data_csv
     CSV.generate do |csv|
      csv << [
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
      if !all_mobility_data_points.blank?
        all_mobility_data_points.each do |data_point|
          csv << [
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
              'date',
              'steps'
      ]
      if !all_fitbit_data_points.blank?
        all_fitbit_data_points.each do |data_point|
        csv << [
                 data_point.header.creation_date_time,
                 data_point.body.step_count
        ]
        end
      end
    end
  end

  def log_in_data_csv
    CSV.generate do |csv|
      csv << [
        'name',
        'version',
        'source name',
        'creation date time',
        'level',
        'event',
        'message'
      ]
      if !all_log_in_data_points.blank?
        all_log_in_data_points.each do |data_point|
          csv << [
            data_point.header.schema_id.name,
            data_point.header.schema_id.version.major.to_s + '.' + data_point.header.schema_id.version.minor.to_s,
            data_point.header.acquisition_provenance.source_name,
            data_point.header.creation_date_time,
            data_point.body.level,
            data_point.body.event,
            data_point.body.msg
          ]
        end
      end
    end
  end

  ### For rendering mobility data for the grapg on the calender in individual participant page
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
    if !all_calendar_data_points.blank?
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
