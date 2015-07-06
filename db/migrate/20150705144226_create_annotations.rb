class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.string :title
      t.string :start
      t.string :end
      t.belongs_to :user, index: true

    end
  end
end
