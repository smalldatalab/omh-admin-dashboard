ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :researcher, :study_ids => [], studies_attributes: [:id, :name], :data_stream_ids => [], data_streams_attributes: [:id, :name] 

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :researcher
    
    column :studies do |q|
      if q.studies.present?
       study_name = q.studies.all.map {|a| a.name.inspect}.join(', ')
       study_name = study_name.gsub /"/, ''
      end 
    end
    column :data_streams do |p|
      if p.data_streams.present?
       data_stream_name = p.data_streams.all.map {|a| a.name.inspect}.join(', ')
       data_stream_name = data_stream_name.gsub /"/, ''
      end 
    end
    column :sign_in_count
    column :created_at
    actions
  end
  
  show do 
    attributes_table do 
      row :id 
      row :email
      row :sign_in_count
      row :created_at
      row :updated_at 
      bool_row :researcher
      row :studies
      row :data_streams
    end
    active_admin_comments
  end 

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :studies, collection: Study.all
  filter :data_streams, collection: DataStream.all 

  form do |f|
    f.inputs "Admin User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :researcher, as: :boolean
      f.input :studies, as: :check_boxes, collection: Study.all
      f.input :data_streams, as: :check_boxes, collection: DataStream.all
    end
    f.actions
  end

end
