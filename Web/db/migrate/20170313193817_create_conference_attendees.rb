class CreateConferenceAttendees < ActiveRecord::Migration[5.0]
  def change
    create_table :conference_attendees do |t|
      t.integer :conference_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end
