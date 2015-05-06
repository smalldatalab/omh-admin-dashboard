class AddSearchKeyNameToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :search_key_name, :string, index: true
  end
end
