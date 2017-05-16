class CreateConferenceResources < ActiveRecord::Migration[5.0]
  def change
    create_table :conference_resources, id: false do |t|
      t.string :conference_resource_id, primary_key: true, null: false, limit: 30
      t.string :conference_id, limit: 30
      t.string :building
      t.string :title
      t.string :event_color
      t.string :parent_id, limit: 30
      t.timestamps
    end

    add_index :conference_resources, :conference_resource_id, unique: true
    add_index :conference_resources, :conference_id
    add_index :conference_resources, :parent_id
  end
end
