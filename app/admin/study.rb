ActiveAdmin.register Study do
  permit_params :name, :remove_gps, :organization_ids => [], organizations_attribute: [:id, :name], :survey_ids => [], surveys_attributes: [:id, :name], :data_stream_ids => [], data_streams_attributes: [:id, :name]
  menu priority: 5

  index do
    selectable_column
    id_column
    column :name
    column :surveys do |q|
      q.surveys.all.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
    end
    column :data_streams do |user|
      user.data_streams.all.map { |a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
    end
    column :remove_gps
    column :created_at
    column :updated_at

    actions
  end

  filter :name
  filter :surveys, as: :select, collection: proc {
    if current_admin_user.organizer? || current_admin_user.researcher?
      current_admin_user.surveys.uniq
    else
      Survey.all
    end
  }
  filter :data_streams, as: :select, collection: proc {DataStream.all}
  filter :remove_gps


  show do
    attributes_table do
      row :name
      row :surveys do |q|
        q.surveys.all.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
      end
      row :data_streams do |user|
        user.data_streams.all.map { |a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
      end
      bool_row :remove_gps
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Study Details" do
      f.input :name
      f.input :data_streams, as: :check_boxes, collection: DataStream.all
      if current_admin_user.organizer?
        f.input :organizations, as: :check_boxes, collection: current_admin_user.organizations, label: "Organizations (Please select your organization from the list)"
        f.input :surveys, as: :check_boxes, collection: current_admin_user.surveys
        f.input :remove_gps, as: :boolean, label: "Remove GPS Data"
      else
        f.input :organizations, as: :check_boxes, collection: Organization.all
        f.input :surveys, as: :check_boxes, collection: Survey.all
        f.input :remove_gps, as: :boolean, label: "Remove GPS Data"
      end
      f.actions
    end
  end
end