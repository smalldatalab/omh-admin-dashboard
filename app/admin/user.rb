ActiveAdmin.register User do
  permit_params :first_name, :last_name, :gmail, :user_id

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  # show do
  #   # actions
  # end

  index do
    selectable_column
    id_column
    column :gmail
    column :first_name
    column :last_name
    column("Pam Data Last Updated") { |user| user.most_recent_pam_data_point }
    column("Mobility Data Last Updated") { |user| user.most_recent_mobility_data_point}
    # column("Download PAM Data") { |user| link_to('Download PAM Data', user_pam_path(user)) }
    actions
  end

  filter :gmail
  filter :first_name
  filter :last_name

  form do |f|
    f.inputs "Admin Details" do
      f.input :gmail
      f.input :first_name
      f.input :last_name
      f.actions
    end
  end

  action_item :only => :show do
    link_to 'Pam Data CSV File', user_pam_data_points_path(user, format: 'csv')
  end

  action_item :only => :show do 
    link_to 'Mobility Data csv File', user_mobility_data_points_path(user, format: 'csv')
  end

  csv do
    column :gmail
    column :first_name
    column :last_name
    column("Pam Data Last Updated") { |user| user.most_recent_pam_data_point }
    column("Mobility Data Last Updated") { |user| user.most_recent_mobility_data_point}
    column (:created_at) { |time| time.created_at.to_formatted_s(:long_ordinal)} 
    column (:updated_at) { |time| time.updated_at.to_formatted_s(:long_ordinal)}
  end

end
