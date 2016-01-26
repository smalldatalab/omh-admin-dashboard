class AddRemovegpsToStudy < ActiveRecord::Migration
  def change
   add_column :studies, :remove_gps, :boolean, default: false
  end
end
