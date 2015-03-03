class CreateSSurvey < ActiveRecord::Migration
  def change
    create_table :s_surveys do |t|
      t.belongs_to :survey, index: true
      t.belongs_to :study, index: true
    end
  end
end
