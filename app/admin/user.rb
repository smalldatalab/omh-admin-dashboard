ActiveAdmin.register User  do
  permit_params :first_name, :last_name, :gmail, :username, :organization_ids => [], organizations_attribute: [:id, :name], :study_ids => [], studies_attributes: [:id, :name], :data_stream_ids => [], data_streams_attributes: [:id, :name]

  menu priority: 3, label: "Participants"

  before_filter :only => :index do
    @per_page = 10
  end

  ##### All data download buttons group for Participant Tab
  action_item :only => :index do
    link_to 'All PAM Data', all_users_pam_data_points_admin_users_path(format: 'csv')
  end

  action_item :only => :index do
    link_to 'All Mobility Data', all_users_mobility_data_points_admin_users_path(format: 'csv')
  end

  action_item :only => :index do
    link_to 'All Fitbit Data', all_users_fitbit_data_points_admin_users_path(format: 'csv')
  end

  collection_action :all_users_pam_data_points do
    respond_to do |format|
      format.csv {render text: all_users_pam_csv }
    end
  end

  collection_action :all_users_mobility_data_points do
    respond_to do |format|
      format.csv {render text: all_users_mobility_csv}
      tracer_bullet
    end
  end

  collection_action :all_users_fitbit_data_points do
    respond_to do |format|
      format.csv {render text: all_users_fitbit_csv}
    end
  end

  ##### Controller for all data download button group (Customized)
  controller do
    def all_users_pam_csv
      @users = current_admin_user.users
      CSV.generate do |csv|
        csv << [
                'user id',
                'id',
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
        @users.each do |user|
          if !user.all_pam_data_points.blank?
            user.all_pam_data_points.each do |data_point|
              csv << [
                    find_user_id(data_point.user_id),
                    data_point._id,
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
    end

    def all_users_mobility_csv
      @users = current_admin_user.users
      CSV.generate do |csv|
        csv << [
                'user id',
                'id',
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
        @users.each do |user|
          if !user.all_mobility_data_points.nil?
            user.all_mobility_data_points
            tracer_bullet
            user.all_mobility_data_points.each do |data_point|
              csv << [
                      find_user_id(data_point.user_id),
                      data_point._id,
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
    end

    def all_users_fitbit_csv
      @users = current_admin_user.users
      CSV.generate do |csv|
        csv << [
                'user_id',
                'id',
                'date',
                'steps'
        ]
        @users.each do |user|
          if !user.all_fitbit_data_points.nil?
            user.all_fitbit_data_points.each do |data_point|
            csv << [
                     find_user_id(data_point.user_id),
                     data_point._id,
                     data_point.header.creation_date_time,
                     data_point.body.step_count
            ]
            end
          end
        end
      end
    end

    def find_user_id(username)
      return User.find_by_username(username).id
    end

    def escape_nil_body(data, attribute)
      data.body.nil? ? nil : data.body.send(attribute)
    end
  end

  ##### Index part for Participant Tab
  index do
    selectable_column
    id_column

    if !current_admin_user.researcher?
      column :studies do |user|
        if user.studies.present?
          user.studies.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      end
      column :surveys do |user|
        if user.surveys.present?
          user.surveys.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      end
      column :data_streams do |user|
        if user.data_streams.present?
          user.data_streams.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      end
    else
      column :studies do |user|
        common_elements = user.studies & current_admin_user.studies
        if common_elements.present?
          common_elements.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      end
      column :surveys do |user|
        common_elements = user.surveys & current_admin_user.surveys
        if common_elements.present?
          common_elements.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      end
      column :data_streams do |user|
        common_elements = user.data_streams & current_admin_user.data_streams
        if common_elements.present?
          common_elements.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      end
    end

    column("Pam Data Last Uploaded") { |user| user.most_recent_data_point_date('photographic-affect-meter-scores')}
    column("Mobility Data Last Uploaded") { |user| user.most_recent_mobility_data_point_date }
    column("Moves Data Last Uploaded") { |user| user.most_recent_data_point_date('mobility-daily-summary', 'moves-app')}
    column("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point_date(current_admin_user.id)}
    column("Fitbit Data Last Uploaded") { |user| user.most_recent_data_point_date('step_count')}
    column("Registered in Database") { |user| user.registrated_in_database }

    actions
  end

  ##### Individual participant Show (Customized)
  show title: :id do
    #### Embed the Calender. Go to views/users/_calender_view.html.erb
    panel "Calendar of Daily Data" do
      render partial: 'calendar_view', locals: { users: @user}
    end

    attributes_table do
      row :id
      ### Access difference for Admin User types
      if !current_admin_user.researcher?
        row :studies do |user|
          ## Strip the quotes and join the name of studies together
          user.studies.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
         row :surveys do |user|
          user.surveys.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
        row :data_streams do |user|
          user.data_streams.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      else
        row :studies do |user|
          ## Get the shared studies of current admin user and the participant
          common_elements = user.studies & current_admin_user.studies
          common_elements.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
        row :surveys do |user|
          common_elements = user.surveys & current_admin_user.surveys
          common_elements.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
        row :data_streams do |user|
          common_elements = user.data_streams & current_admin_user.data_streams
          common_elements.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      end
      ## Call back the methods defined in models/user.rb
      row("Pam Data Last Uploaded") { |user| user.most_recent_data_point_date('photographic-affect-meter-scores')}
      row("Mobility Data Last Uploaded") { |user| user.most_recent_mobility_data_point_date}
      row("Moves Data Last Uploaded") { |user| user.most_recent_data_point_date('mobility-daily-summary', 'moves-app')}
      row("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point_date(current_admin_user.id)}
      row("Fitbit Data Last Uploaded") { |user| user.most_recent_data_point_date('step_count')}
      row("Registered in Database") { |user| user.registrated_in_database }

      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  ##### CSV download buttons in individual participant page (Customized)
  action_item :only => :show do
    link_to 'PAM Data CSV File', admin_user_pam_data_points_path(user, format: 'csv')
  end

  action_item :only => :show do
    link_to 'Mobility/Moves Data csv File', admin_user_mobility_daily_summary_data_points_path(user, format: 'csv')
  end

  action_item :only => :show do
    link_to 'ohmage Data csv File', admin_user_ohmage_data_points_path(user, format: 'csv')
  end

  action_item :only => :show do
    link_to 'Fitbit Data csv File', admin_user_fitbit_data_points_path(user, format: 'csv')
  end

  action_item :only => :show do
    link_to 'Logging Data csv File', admin_user_log_in_data_points_path(user, format: 'csv')
  end

  ##### Filter (Customized)
  filter :id
  filter :data_streams, as: :select, collection: proc { DataStream.all }
  filter :surveys, as: :select, collection: proc {
    if current_admin_user.organizer? || current_admin_user.researcher?
      current_admin_user.surveys.uniq
    else
      Survey.all
    end
  }
  filter :studies, as: :select, collection: proc {
    if current_admin_user.organizer?
      Study.joins(:organizations).where('organizations.id IN (?)', current_admin_user.organizations.ids)
    elsif current_admin_user.researcher?
      current_admin_user.studies
    else
      Study.all
    end
  }

  ##### Input (Customized)
  form do |f|
    f.inputs "User Details" do
      f.input :gmail
      f.input :first_name
      f.input :last_name
      f.input :username
      if current_admin_user.organizer?
        f.input :studies, as: :check_boxes, collection: Study.joins(:organizations).where('organizations.id IN (?)', current_admin_user.organizations.ids)
      else
        f.input :studies, as: :check_boxes, collection: Study.all
      end
    end
    f.actions
  end

  ##### Index CSV Format (Customized)
  csv do
    column :id
    column("Studies") {|user| user.studies.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, '' }
    column("Data Streams") {|user| user.data_streams.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, '' }
    column("Surveys") {|user| user.surveys.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''}
    column("Pam Data Last Uploaded") { |user| user.most_recent_data_point_date('photographic-affect-meter-scores')}
    column("Mobility Data Last Uploaded") { |user| user.most_recent_mobility_data_point_date }
    column("Moves Data Last Uploaded") { |user| user.most_recent_data_point_date('mobility-daily-summary', 'moves-app')}
    column("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point_date(current_admin_user.id)}
    column("Fitbit Data Last Uploaded") { |user| user.most_recent_data_point_date('step_count')}
    column (:created_at) { |time| time.created_at.to_formatted_s(:long_ordinal)}
    column (:updated_at) { |time| time.updated_at.to_formatted_s(:long_ordinal)}
  end

end

