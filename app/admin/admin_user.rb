ActiveAdmin.register AdminUser do
  permit_params :email, :password, :send_email, :password_confirmation, :organizer, :researcher, :organization_ids => [], organizations_attributes: [:id, :name],:study_ids => [], studies_attributes: [:id, :name], :data_stream_ids => [], data_streams_attributes: [:id, :name]
  menu priority: 2, label: "Administrators"

  index do
    selectable_column
    id_column

    column :email
    column :current_sign_in_at
    if !current_admin_user.researcher? && !current_admin_user.organizer?
      column :organizer
      column :organizations do |q|
        if q.organizations.present?
         organization_name = q.organizations.all.map {|a| a.name.inspect}.uniq.join(', ')
         organization_name = organization_name.gsub /"/, ''
        end
      end
    end
    column :researcher
    column :studies do |q|
      if q.studies.present?
       study_name = q.studies.all.map {|a| a.name.inspect}.uniq.join(', ')
       study_name = study_name.gsub /"/, ''
      elsif q.organizer?
        if q.organizations.first.studies.present?
          studies_name = Study.joins(:organizations).where('organizations.id IN (?)', q.organizations.ids).all.map {|a| a.name.inspect}.uniq.join(', ')
          studies_name = studies_name.gsub /"/, ''
        end
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
        row :organizations do |q|
          if q.organizations.present?
           organization_name = q.organizations.all.map {|a| a.name.inspect}.uniq.join(', ')
           organization_name = organization_name.gsub /"/, ''
          end
        end
      end
      bool_row :researcher
      row :studies do |q|
        if q.studies.present?
         study_name = q.studies.all.map {|a| a.name.inspect}.uniq.join(', ')
         study_name = study_name.gsub /"/, ''
        elsif q.organizer?
          if q.organizations.first.studies.present?
            studies_name = Study.joins(:organizations).where('organizations.id IN (?)', q.organizations.ids).all.map {|a| a.name.inspect}.uniq.join(', ')
            studies_name = studies_name.gsub /"/, ''
          end
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
        f.input :studies, as: :check_boxes, collection: Study.joins(:organizations).where('organizations.id IN (?)', current_admin_user.organizations.ids)
        f.input :organizations, as: :check_boxes, collection: current_admin_user.organizations
      elsif !current_admin_user.researcher?
        f.input :studies, as: :check_boxes, collection: Study.all
        f.input :organizations, as: :check_boxes, collection: Organization.all
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
