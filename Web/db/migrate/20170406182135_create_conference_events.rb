class CreateConferenceEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :conference_events do |t|
      t.string :conference_resource_id, limit: 30
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
    end

    change_column :conference_events, :id, :string, limit: 30
    add_index :conference_events, :conference_resource_id

  end
end
