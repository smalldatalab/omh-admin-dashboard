ActiveAdmin.register User  do
  permit_params :first_name, :last_name, :gmail, :user_name_id, :study_ids => [], studies_attributes: [:id, :name], :data_stream_ids => [], data_streams_attributes: [:id, :name]

  menu priority: 3, label: "Participants"

  index do
    selectable_column
    id_column
    # if current_admin_user.researcher?
    #   column :gmail
    # end

    # if current_admin_user.researcher?
    #   column :first_name
    # end

    # if current_admin_user.researcher?
    #   column :last_name
    # end
    # column :user_name_id

    if !current_admin_user.researcher?
      column :studies do |user|
        user.studies.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
      end
    else
      column :studies do |user|
        a = user.studies & current_admin_user.studies
        a.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
      end
    end

    if !current_admin_user.researcher?
      column :surveys do |user|
        user.surveys.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
      end
    else
      column :surveys do |user|
        common_elements = user.surveys & current_admin_user.surveys
        common_elements.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
      end
    end

    if !current_admin_user.researcher?
      column :data_streams do |user|
        user.data_streams.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
      end
    else
      column :data_streams do |user|
        common_elements = user.data_streams & current_admin_user.data_streams
        common_elements.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
      end
    end
    column("Pam Data Last Uploaded") { |user| user.most_recent_data_point_date('photographic-affect-meter-scores')}
    column("Mobility Data Last Uploaded") { |user| user.most_recent_data_point_date('mobility-daily-summary', 'ios' || 'android')}
    column("Moves Data Last Uploaded") { |user| user.most_recent_data_point_date('mobility-daily-summary', 'moves-app')}
    column("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point_date(current_admin_user.id)}
    column("Registered in Database") { |user| user.registrated_in_database }

    actions
  end


  show do
  # :title => proc {|user| (user.first_name.blank? && user.last_name.blank?) ? user.gmail : ( user.first_name.blank? ? user.last_name : user.first_name ) }  do
    panel "Calendar View" do
      render partial: 'calendar_view', locals: { users: @user}
    end

    attributes_table do
      row :id
      # if current_admin_user.researcher?
      #   row :gmail
      # end

      # if current_admin_user.researcher?
      #   row :first_name
      # end

      # if current_admin_user.researcher?
      #   row :last_name
      # end
      # row :user_name_id

      if !current_admin_user.researcher?
        row :studies do |user|
          user.studies.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      else
        row :studies do |user|
          common_elements = user.studies & current_admin_user.studies
          common_elements.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      end

      if !current_admin_user.researcher?
        row :surveys do |user|
          user.surveys.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      else
        row :surveys do |user|
          common_elements = user.surveys & current_admin_user.surveys
          common_elements.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      end


      if !current_admin_user.researcher?
        row :data_streams do |user|
          user.data_streams.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      else
        row :data_streams do |user|
          common_elements = user.data_streams & current_admin_user.data_streams
          common_elements.map {|b| b.name.inspect}.uniq.join(', ').gsub /"/, ''
        end
      end

      row("Pam Data Last Uploaded") { |user| user.most_recent_data_point_date('photographic-affect-meter-scores')}
      row("Mobility/Moves Data Last Uploaded") { |user| user.most_recent_data_point_date('mobility-daily-summary')  }
      row("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point_date(current_admin_user.id)}
      row("Registered in Database") { |user| user.registrated_in_database }

      row :created_at
      row :updated_at
    end
    active_admin_comments
  end


  # filter :gmail
  # filter :first_name
  # filter :last_name
  filter :studies, collection: Study.all
  filter :data_streams, collection: DataStream.all
  filter :surveys, collection: Survey.all

  form do |f|
    f.inputs "User Details" do
      f.input :gmail
      f.input :first_name
      f.input :last_name
      f.input :user_name_id
      f.input :studies, as: :check_boxes, collection: Study.all
      # current_admin_user.studies
    end
    f.actions
  end

  action_item :only => :show do
    link_to 'PAM Data CSV File', admin_user_pam_data_points_path(user, format: 'csv')
  end

  action_item :only => :show do
    link_to 'Mobility/Moves Data csv File', admin_user_mobility_daily_summary_data_points_path(user, format: 'csv')
  end

  action_item :only => :show do
    link_to 'ohmage Data csv File', admin_user_ohmage_data_points_path(user, format: 'csv')
  end



  csv do
    # column :gmail
    # column :first_name
    # column :last_name
    column("Studies") {|user| user.studies.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, '' }
    column("Data Streams") {|user| user.data_streams.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, '' }
    column("Surveys") {|user| user.surveys.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''}
    column("PAM Data Last Uploaded") { |user| user.most_recent_data_point_date('photographic-affect-meter-scores') }
    column("Mobility/Moves Data Last Uploaded") { |user| user.most_recent_data_point_date('mobility-daily-summary')}
    column("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point_date(current_admin_user.id)}
    column (:created_at) { |time| time.created_at.to_formatted_s(:long_ordinal)}
    column (:updated_at) { |time| time.updated_at.to_formatted_s(:long_ordinal)}
  end

end

