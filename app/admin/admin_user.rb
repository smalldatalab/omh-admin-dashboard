ActiveAdmin.register AdminUser do
  permit_params :id, :email, :password, :password_confirmation, :researcher, :study_ids => [], studies_attributes: [:id, :name], :data_stream_ids => [], data_streams_attributes: [:id, :name]
  menu priority: 2, label: "Administrators"

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :researcher

    column :studies do |q|
      if q.studies.present?
       study_name = q.studies.all.map {|a| a.name.inspect}.uniq.join(', ')
       study_name = study_name.gsub /"/, ''
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
      row :studies do |q|
        if q.studies.present?
         study_name = q.studies.all.map {|a| a.name.inspect}.uniq.join(', ')
         study_name = study_name.gsub /"/, ''
        end
      end

    end
    active_admin_comments
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :studies, collection: Study.all


  form do |f|
    f.inputs "Admin User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      if !current_admin_user.researcher?
        f.input :researcher, as: :boolean
        f.input :studies, as: :check_boxes, collection: Study.all
      end
    end
    f.actions
  end

  controller do
    def update
      if params[:admin_user][:password].blank? && params[:admin_user][:password_confirmation].blank?
        params[:admin_user].delete("password")
        params[:admin_user].delete("password_confirmation")
      end
      super
    end
  end

end
