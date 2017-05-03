class RenameBuildingToRoom < ActiveRecord::Migration[5.0]
  def change
    rename_column :conference_resources, :building, :room
  end
end
