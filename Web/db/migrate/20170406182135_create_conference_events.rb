class CreateConferenceEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :conference_events, id: false do |t|
      t.string :conference_event_id, primary_key: true, null: false, limit: 30
      t.string :conference_resource_id, limit: 30
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
    end

    add_index :conference_events, :conference_event_id, unique: true
    add_index :conference_events, :conference_resource_id

  end
end
