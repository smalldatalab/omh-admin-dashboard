ActiveAdmin.register AdminUser do
  # belongs_to :organization
  permit_params :email, :password, :send_email, :password_confirmation, :researcher, :organizer, :organization_id, organization_attributes: [:id, :name],:study_ids => [], studies_attributes: [:id, :name], :data_stream_ids => [], data_streams_attributes: [:id, :name]
  menu priority: 2, label: "Administrators"

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    if !current_admin_user.researcher? && !current_admin_user.organizer?
      column :organizer
      column :organization
    end
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
      if !current_admin_user.researcher? && !current_admin_user.organizer?
        bool_row :organizer
        row :organization
      end
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
  filter :studies, as: :select, collection: proc{Study.all}
  # if !current_admin_user.researcher? && !current_admin_user.organizer?
  # filter :organization, as: :select, collection: proc{Organization.all}
  # end


  form do |f|
    f.inputs "Admin User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :organizer, as: :boolean
      f.input :researcher, as: :boolean
      if current_admin_user.organizer?
        f.input :studies, as: :check_boxes, collection: current_admin_user.organization.studies
        f.input :organization, :input_html => {:value => current_admin_user.organization}, include_blank: false, allow_blank: false
      elsif !current_admin_user.researcher?
        f.input :studies, as: :check_boxes, collection: Study.all
        f.input :organization
      end
      f.input :send_email, as: :boolean
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
