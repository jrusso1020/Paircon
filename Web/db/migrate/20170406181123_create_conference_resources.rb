class CreateConferenceResources < ActiveRecord::Migration[5.0]
  def change
    create_table :conference_resources do |t|
      t.string :conference_id, limit: 30
      t.string :building
      t.string :title
      t.string :event_color
      t.string :parent_id, limit: 30
      t.timestamps
    end

    change_column :conference_resources, :id, :string, limit: 30
    change_column :conference_attendees, :id, :string, limit: 30
    change_column :conference_organizers, :id, :string, limit: 30
    change_column :conference_resources, :id, :string, limit: 30
    change_column :activities, :id, :string, limit: 30
    change_column :similarities, :id, :string, limit: 30
    change_column :papers, :id, :string, limit: 30
    change_column :organizers, :id, :string, limit: 30
    change_column :identities, :id, :string, limit: 30

    add_index :conference_resources, :conference_id
    add_index :conference_resources, :parent_id
  end
end
