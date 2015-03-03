class CreateSDataStream < ActiveRecord::Migration
  def change
    create_table :s_data_streams do |t|
      t.belongs_to :study, index: true
      t.belongs_to :data_stream, index: true
    end
  end
end
