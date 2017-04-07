class UpdateEventColors < ActiveRecord::Migration[5.0]
  def change
    rename_column :conference_resources, :event_color, :eventColor
    add_column :conference_events, :color, :string

  end
end
