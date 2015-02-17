ActiveAdmin.register User  do
  permit_params :first_name, :last_name, :gmail, :study_ids => [], studies_attributes: [:id, :name], :data_stream_ids => [], data_streams_attributes: [:id, :name] 

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  # show do
  #   # actions
  # end

  index do
    selectable_column
    # id_column
    column :gmail
    column :first_name
    column :last_name
    column :studies do |user|
      if user.studies.present?
       study_name = user.studies.all.map {|a| a.name.inspect}.join(', ')
       study_name = study_name.gsub /"/, ''
      end 
    end
    column :data_streams do |user|
      if user.data_streams.present? 
        data_stream_name = user.data_streams.all.map { |a| a.name.inspect}.join(', ')
        data_stream_name = data_stream_name.gsub /"/, ''
      end 
    end 
    column("Pam Data Last Uploaded") { |user| user.most_recent_pam_data_point }
    column("Mobility Data Last Uploaded") { |user| user.most_recent_mobility_data_point}
    column("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point}
    # column("Download PAM Data") { |user| link_to('Download PAM Data', user_pam_path(user)) }
    actions
  end
  

  show do 
    panel "Calendar View" do
      render partial: 'calendar_view', locals: { users: @user}
    end 
    attributes_table do 
      row :id
      row :first_name
      row :last_name
      row :gmail
      row :studies do |user|
        if user.studies.present?
          study_name = user.studies.all.map {|a| a.name.inspect}.join(', ')
          study_name = study_name.gsub /"/, ''
        end 
      end
      row :data_streams do |user|
        if user.data_streams.present? 
          data_stream_name = user.data_streams.all.map { |a| a.name.inspect}.join(', ')
          data_stream_name = data_stream_name.gsub /"/, ''
        end 
      end 
      row("PAM Data Last Uploaded") { |user| user.most_recent_pam_data_point }
      row("Mobility Data Last Uploaded") { |user| user.most_recent_mobility_data_point}
      row("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point}
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

  form do |f|
    f.inputs "User Details" do
      f.input :gmail
      f.input :first_name
      f.input :last_name
      # f.input :studies, as: :check_boxes, collection: Study.all_names 
     
      # f.has_many :studies do |study_f|
      #   study_f.inputs "Studies" do 
      #     # if !study_f.object.nil? 
      #     #   study_f.input :destroy, as: :boolean, label: "Destroy?"
      #     # end 
      #     study_f.input :studies, collection: Study.all_names 

    # f.inputs "Studies" do
    #   f.has_many :studies do |j|
    #     j.inputs :study_name, collection: Study.all_names 
    #   end
     
      f.input :studies, as: :check_boxes, collection: Study.all
      f.input :data_streams, as: :check_boxes, collection: DataStream.all
    end
      # f.input :study_name, collection: Study.all_names
    f.actions  
  end

  action_item :only => :show do
    link_to 'PAM Data CSV File', admin_user_pam_data_points_path(user, format: 'csv')
  end

  action_item :only => :show do 
    link_to 'Mobility Data csv File', admin_user_mobility_data_points_path(user, format: 'csv')
  end

  action_item :only => :show do
    link_to 'ohmage Data csv File', admin_user_ohmage_data_points_path(user, format: 'csv') 
  end

  # action_item :only => :show do 
  #   link_to 'calendar data json', admin_user_calendar_data_points_path(user, format: 'json')
  # end

  csv do
    column :gmail
    column :first_name
    column :last_name
    column("Studies") {|user| user.studies.all.map {|a| a.name.inspect}.join(', ').gsub /"/, '' }
    column("Data Streams") {|user| user.data_streams.all.map {|a| a.name.inspect}.join(', ').gsub /"/, '' }
    column("PAM Data Last Uploaded") { |user| user.most_recent_pam_data_point }
    column("Mobility Data Last Uploaded") { |user| user.most_recent_mobility_data_point}
    column("ohmage Data Last Uploaded") { |user| user.most_recent_ohmage_data_point}
    column (:created_at) { |time| time.created_at.to_formatted_s(:long_ordinal)} 
    column (:updated_at) { |time| time.updated_at.to_formatted_s(:long_ordinal)}
  end

end

