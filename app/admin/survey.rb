ActiveAdmin.register Survey do
  permit_params :name, :version, :description, :share, :definition

  index do
    selectable_column
    id_column
    column :name
    column :version
    column :description
    column :share
    column :definition

   
    actions
  end

  filter :name
  filter :version


  show do 
     attributes_table do 
      row :id 
      row :version
      row :description
      row :definition
      row :created_at 
      row :updated_at
      bool_row :share

    end
    active_admin_comments
  end 

  form do |f|
    f.inputs "Survey Details" do
      f.input :name
      f.input :version 
      f.input :description
      f.input :share, as: :boolean
      f.input :definition, as: :text, validates: true
    end
  f.actions
  end
end 