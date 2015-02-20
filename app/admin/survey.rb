ActiveAdmin.register Survey do
  permit_params :name, :version, :description, :definition

  index do
    selectable_column
    id_column
    column :name
    column :version
    column :description
    column :definition
   
    actions
  end

  filter :name


  form do |f|
    f.inputs "Survey Details" do
      f.input :name
      f.input :version 
      f.input :description
      f.input :definition, as: :text, validates: true
    end
  f.actions
  end
end 