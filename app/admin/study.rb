ActiveAdmin.register Study do 
  permit_params :name
  
  index do
    selectable_column
    id_column
    column :name
    # column :study_date 
    # column("Pam Data Last Updated") { |user| user.most_recent_pam_data_point }
    # column("Mobility Data Last Updated") { |user| user.most_recent_mobility_data_point}
    # column("Download PAM Data") { |user| link_to('Download PAM Data', user_pam_path(user)) }
    actions
  end

  filter :name
  # filter :study_date


  form do |f|
    f.inputs "Study Details" do
      f.input :name
      # f.input :study_date

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