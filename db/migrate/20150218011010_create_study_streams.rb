class CreateStudyStreams < ActiveRecord::Migration
  def change
    create_table :study_streams do |t|
      t.belongs_to :study, index: true
      t.belongs_to :data_stream, index: true
      t.belongs_to :admin_stream, index: true


      t.timestamps 
    end
  end
end
