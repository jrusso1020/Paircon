class AddFieldsPaperResource < ActiveRecord::Migration[5.0]
  def change
    remove_column :papers, :keywords
    add_column :papers, :abstract, :text
    add_column :paper_authors, :email, :string
    add_column :conference_events, :presenter, :string
    add_column :conference_events, :event_type, :integer, default: 0
  end
end
