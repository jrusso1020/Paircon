class CreateConferenceOrganizers < ActiveRecord::Migration[5.0]
  def change
    create_table :conference_organizers, id: false do |t|
      t.string :conference_organizer_id, primary_key: true, null: false, limit: 30
      t.string :conference_id, limit: 30
      t.string :user_id, limit: 30

      t.timestamps
    end

    add_index :conference_organizers, :conference_organizer_id, unique: true

  end
end
