ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :researcher, :study_ids => [], studies_attributes: [:id, :name] 

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :researcher
    column :studies do |admin_user|
      if admin_user.studies.present?
       study_name = admin_user.studies.all.map {|a| a.name.inspect}.join(', ')
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
    end
    active_admin_comments
  end 
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :researcher, as: :boolean
      f.input :studies, as: :check_boxes, collection: Study.all
    end
    f.actions
  end

end
