ActiveAdmin.register Study do
  permit_params :name, :survey_ids => [], surveys_attributes: [:id, :name], :data_stream_ids => [], data_streams_attributes: [:id, :name]
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

    actions
  end

  filter :name
  filter :surveys, as: :select, collection: proc{Survey.all}
  filter :data_streams, as: :select, collection: proc{DataStream.all}


  show do
    attributes_table do
      row :name
      row :surveys do |q|
        q.surveys.all.map {|a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
      end
      row :data_streams do |user|
        user.data_streams.all.map { |a| a.name.inspect}.uniq.join(', ').gsub /"/, ''
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Study Details" do
      f.input :name
      f.input :surveys, as: :check_boxes, collection: Survey.all
      f.input :data_streams, as: :check_boxes, collection: DataStream.all

      f.actions
    end
  end
end