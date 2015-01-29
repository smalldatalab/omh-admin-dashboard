ActiveAdmin.register DataStream do
  permit_params :name
  
  index do
    selectable_column
    id_column
    column :name
    actions
  end

  filter :name


  form do |f|
    f.inputs "Data Stream Details" do
      f.input :name
      # f.input :study_date

      f.actions
    end
  end
end 