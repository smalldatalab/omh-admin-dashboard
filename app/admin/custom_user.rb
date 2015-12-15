ActiveAdmin.register CustomUser do
  permit_params :username, :password, :annotation, :study_ids => [], studies_attributes: [:id, :name]

  index do |f|
    selectable_column
    id_column

    column :username
    column :annotation
    # column :created_at
    # column :updated_at
    column :studies do |user|
      user.studies.all.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
    end

    actions
  end

  show do |f|
    attributes_table do
      row :username
      row :annotation
      # row :created_at
      # row :updated_at

      row :studies do |user|
        user.studies.all.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
      end

    end
    active_admin_comments
  end

  filter :username
  filter :annotation

  form do |f|
    f.inputs "Custom User Details" do
      f.input :username
      f.input :password
      f.input :annotation
      if current_admin_user.organizer?
        f.input :studies, as: :check_boxes, collection: Study.joins(:organizations).where('organizations.id IN (?)', current_admin_user.organizations.ids)
      else
        f.input :studies, as: :check_boxes, collection: Study.all
      end
    end
    f.actions
  end

end