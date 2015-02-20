class CreateStudySurveys < ActiveRecord::Migration
  def change
    create_table :study_surveys do |t|
      t.belongs_to :survey, index: true
      t.belongs_to :study, index: true

      t.timestamps 
    end
  end
end
