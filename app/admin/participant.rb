ActiveAdmin.register Participant do 
  permit_params :first_name, :last_name, :gmail


  index do
    selectable_column
    id_column
    column :gmail
    column :first_name
    column :last_name
    column :password 
    column :study_name 
  end 

  filter :gmail
  filter :first_name
  filter :last_name
  filter :study_name

  form do |f|
    f.inputs "Participant Details" do
      f.input :gmail
      f.input :first_name
      f.input :last_name
      f.input :password
      f.input :study_name, as: :check_boxes, collection: Study.all_names
      f.actions
    end
  end

  # action_item :only => :show do
  #   link_to 'Pam Data CSV File', user_pam_data_points_path(user, format: 'csv')
  # end

  # action_item :only => :show do 
  #   link_to 'Mobility Data csv File', user_mobility_data_points_path(user, format: 'csv')
  # end
end 