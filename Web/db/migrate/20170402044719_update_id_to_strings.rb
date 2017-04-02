class UpdateIdToStrings < ActiveRecord::Migration[5.0]
  def change
    change_column :similarities, :paper_id1, :string, limit: 30
    change_column :similarities, :paper_id2, :string, limit: 30
    change_column :conference_attendees, :conference_id, :string, limit: 30
    change_column :conference_attendees, :user_id, :string, limit: 30
    change_column :conference_organizers, :conference_id, :string, limit: 30
    change_column :conference_organizers, :user_id, :string, limit: 30
    change_column :conference_papers, :paper_id, :string, limit: 30
    change_column :conference_papers, :conference_id, :string, limit: 30
    change_column :conferences, :id, :string, limit: 30
    change_column :organizers, :id, :string, limit: 30
    change_column :papers, :id, :string, limit: 30
    change_column :paper_authors, :paper_id, :string, limit: 30
    change_column :paper_authors, :user_id, :string, limit: 30
  end
end
