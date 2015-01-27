class CreateStudyParticipants < ActiveRecord::Migration
  def change
    create_table :study_participants do |t|
      t.belongs_to :study, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
