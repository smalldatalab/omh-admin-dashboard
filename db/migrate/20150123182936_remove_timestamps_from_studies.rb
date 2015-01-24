class RemoveTimestampsFromStudies < ActiveRecord::Migration
  def change
    remove_column :studies, :created_at, :string
    remove_column :studies, :updated_at, :string
  end
end
