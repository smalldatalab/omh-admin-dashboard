ActiveAdmin.register_page "Dashboard" do
  menu label: "About", priority: 1

  content do
    render partial: 'intro_view'
  end
end
