ActiveAdmin.register User  do
  permit_params :first_name, :last_name, :gmail, :study_ids => [], studies_attributes: [:id, :name], :data_stream_ids => [], data_streams_attributes: [:id, :name]

  menu priority: 3, label: "Participants"

  index do
    selectable_column
    id_column
    column :gmail
    column :first_name
    column :last_name
    column :studies do |user|
      user.studies.all.map {|a| a.name.inspect}.join(', ').gsub /"/, ''
    end
    column :data_streams do |user|
      user.data_streams.all.uniq.map { |a| a.name.inspect}.join(', ').gsub /"/, ''
    end
    column :surveys do |user|
      user.surveys.all.uniq.map { |a| a.name.inspect}.join(', ').gsub /"/, ''
    end
    column("Registered in Database") { |user| user.registrated_in_database }
    column("Pam Data Last Uploaded") { |user| user.most_recent_data_point_date('photographic-affect-meter-scores')}
    column("Mobility Data Last Uploaded") { |user| user.most_recent_data_point_date('mobility-daily-summary')  }
    column("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point_date}

    actions
  end


  show :title => proc {|user| (user.first_name.blank? && user.last_name.blank?) ? user.gmail : ( user.first_name.blank? ? user.last_name : user.first_name ) }  do
    panel "Calendar View" do
      render partial: 'calendar_view', locals: { users: @user}
    end

    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :gmail
      row :studies do |user|
        user.studies.all.map {|a| a.name.inspect}.join(', ').gsub /"/, ''
      end
      row :data_streams do |user|
        user.data_streams.all.map { |a| a.name.inspect}.join(', ').gsub /"/, ''
      end
      row :surveys do |user|
        user.surveys.all.map { |a| a.name.inspect}.join(', ').gsub /"/, ''
      end
      row("Registered in Database") { |user| user.registrated_in_database }
      row("Pam Data Last Uploaded") { |user| user.most_recent_data_point_date('photographic-affect-meter-scores')}
      row("Mobility Data Last Uploaded") { |user| user.most_recent_data_point_date('mobility-daily-summary')  }
      row("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point_date}

      row :created_at
      row :updated_at
    end
    active_admin_comments
  end


  filter :gmail
  filter :first_name
  filter :last_name
  filter :studies, collection: Study.all
  filter :data_streams, collection: DataStream.all
  filter :surveys, collection: Survey.all

  form do |f|
    f.inputs "User Details" do
      f.input :gmail
      f.input :first_name
      f.input :last_name
      f.input :studies, as: :check_boxes, collection: Study.all
      # current_admin_user.studies
    end
    f.actions
  end

  action_item :only => :show do
    link_to 'PAM Data CSV File', admin_user_pam_data_points_path(user, format: 'csv')
  end

  # action_item :only => :show do
  #   link_to 'Mobility Data csv File', admin_user_mobility_data_points_path(user, format: 'csv')
  # end

  action_item :only => :show do
    link_to 'Mobility Daily Summary Data csv File', admin_user_mobility_daily_summary_data_points_path(user, format: 'csv')
  end

  # action_item :only => :show do
  #   link_to 'ohmage Data csv File', admin_user_ohmage_data_points_path(user, format: 'csv')
  # end



  csv do
    column :gmail
    column :first_name
    column :last_name
    column("Studies") {|user| user.studies.all.map {|a| a.name.inspect}.join(', ').gsub /"/, '' }
    column("Data Streams") {|user| user.data_streams.all.map {|a| a.name.inspect}.join(', ').gsub /"/, '' }
    column("Surveys") {|user| user.surveys.all.map {|a| a.name.inspect}.join(', ').gsub /"/, ''}
    column("PAM Data Last Uploaded") { |user| user.most_recent_data_point_date('photographic-affect-meter-scores') }
    column("Mobility Data Last Uploaded") { |user| user.most_recent_data_point_date('mobility-daily-summary')}
    column("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point_date}
    column (:created_at) { |time| time.created_at.to_formatted_s(:long_ordinal)}
    column (:updated_at) { |time| time.updated_at.to_formatted_s(:long_ordinal)}
  end

end

