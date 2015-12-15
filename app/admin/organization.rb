ActiveAdmin.register Organization do
  permit_params :name, :study_ids => [], studies_attributes: [:id, :name]
  menu priority: 4

  index do
    selectable_column
    id_column
    column :name
    column :studies do |q|
      q.studies.all.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
    end
    column :created_at
    column :updated_at

    actions
  end

  filter :name

  show do
    attributes_table do
      row :name
      row :studies do |q|
        q.studies.all.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Study Details" do
      f.input :name
      if !current_admin_user.researcher? && !current_admin_user.organizer?
        f.input :studies, as: :check_boxes, collection: Study.all
      end
      f.actions
    end
  end
end