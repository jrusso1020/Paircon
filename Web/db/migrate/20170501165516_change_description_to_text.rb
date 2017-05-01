class ChangeDescriptionToText < ActiveRecord::Migration[5.0]
  def change
    change_column :conferences, :description, :text
    end
end
