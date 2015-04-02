ActiveAdmin.register DataStream do
  permit_params :name
  menu priority: 6
  
  index do
    selectable_column
    id_column
    column :name
    column :studies do |q|
      q.studies.all.map {|a| a.name.inspect}.join(', ').gsub /"/, ''
    end
    
    actions
  end

  filter :name

  
  form do |f|
    f.inputs "Data Stream Details" do
      f.input :name
    
      f.actions
    end
  end
end 