ActiveAdmin.register CustomUser do
  permit_params :username, :password, :annotation

  index do |f|
    selectable_column
    id_column

    column :username
    column :annotation

    actions
  end

  show do |f|
    attributes_table do
      row :username
      row :annotation
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Custom User Details" do
      f.input :username
      f.input :password
      f.input :annotation
    end
    f.actions
  end



end