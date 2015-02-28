class ChangeDefinitionTypeInSurvey < ActiveRecord::Migration
  def change 
     change_column :surveys, :definition, :text
  end
end
