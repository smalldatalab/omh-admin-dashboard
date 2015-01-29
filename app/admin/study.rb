ActiveAdmin.register Study do 
  permit_params :name
  
  index do
    selectable_column
    id_column
    column :name
    actions
  end

  filter :name


  form do |f|
    f.inputs "Study Details" do
      f.input :name

      f.actions
    end
  end
end 