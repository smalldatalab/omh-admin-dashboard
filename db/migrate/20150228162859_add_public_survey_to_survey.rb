class AddPublicSurveyToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :public_survey, :boolean, default: false 
  end
end
