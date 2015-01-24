class AddStudyToUser < ActiveRecord::Migration
  def change
  	add_column :users, :study_name, :string
  end
end
