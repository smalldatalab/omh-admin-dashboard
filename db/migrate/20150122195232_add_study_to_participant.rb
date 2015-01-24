class AddStudyToParticipant < ActiveRecord::Migration
  def change
  	add_column :participants, :password, :string  
  	add_column :participants, :study_name, :string
  end
end
