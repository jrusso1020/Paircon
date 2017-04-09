class AddConferenceIdToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :conference_events, :conference_id, :string, limit: 30
  end
end
