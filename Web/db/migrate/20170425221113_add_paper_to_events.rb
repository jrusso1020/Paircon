class AddPaperToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :conference_events, :paper_id, :string
  end
end
