ActiveAdmin.register Survey do
  permit_params :name, :version, :description, :open_to_all, :definition

  index do
    selectable_column
    id_column
    column :name
    column :version
    column :description
    column :open_to_all
    column :definition

   
    actions
  end

  filter :name
  filter :version
  filter :open_to_all

  show do 
     attributes_table do 
      row :id 
      row :version
      row :description
      row :definition
      row :created_at 
      row :updated_at
      bool_row :open_to_all

    end
    active_admin_comments
  end 

  form do |f|
    f.inputs "Survey Details" do
      f.input :name
      f.input :version 
      f.input :description
      f.input :open_to_all, as: :boolean
      f.input :definition, as: :text, validates: true
    end
  f.actions
  end
end 