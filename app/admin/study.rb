ActiveAdmin.register Study do 
  permit_params :name, :survey_ids => [], surveys_attributes: [:id, :name], :data_stream_ids => [], data_streams_attributes: [:id, :name] 
  
  index do
    selectable_column
    id_column
    column :name
    column :surveys do |q|
      if q.surveys.present?
       survey_name = q.surveys.all.map {|a| a.name.inspect}.join(', ')
       survey_name = survey_name.gsub /"/, ''
      end 
    end
    column :data_streams do |user|
      if user.data_streams.present? 
        data_stream_name = user.data_streams.all.map { |a| a.name.inspect}.join(', ')
        data_stream_name = data_stream_name.gsub /"/, ''
      end 
    end 

    actions
  end

  filter :name
  filter :surveys, collection: Survey.all
  filter :data_streams, collection: DataStream.all


  show do
    attributes_table do 
      row :name
      row :surveys do |q|
        if q.surveys.present?
         survey_name = q.surveys.all.map {|a| a.name.inspect}.join(', ')
         survey_name = survey_name.gsub /"/, ''
        end 
      end
      row :data_streams do |user|
        if user.data_streams.present? 
          data_stream_name = user.data_streams.all.map { |a| a.name.inspect}.join(', ')
          data_stream_name = data_stream_name.gsub /"/, ''
        end 
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