ActiveAdmin.register Survey do
  permit_params :name, :version, :public_survey, :description, :definition

  index do
    selectable_column
    id_column
    column :name
    column :version
    column :description
    column :definition
    column :public_survey
   
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
      bool_row :public_survey

    end
    active_admin_comments
  end 

  form do |f|
    f.inputs "Survey Details" do
      f.input :name
      f.input :version 
      f.input :description
      f.input :public_survey
      f.input :definition, as: :text, validates: true
    end
  f.actions
  end
end 