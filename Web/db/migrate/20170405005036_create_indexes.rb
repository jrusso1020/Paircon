class CreateIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :identities, :user_id
    add_index :posts, :conference_id
    add_index :organizers, :user_id, unique: true
    add_index :conference_attendees, [:user_id, :conference_id], unique: true
    add_index :conference_organizers, [:user_id, :conference_id], unique: true
    add_index :conference_papers, [:paper_id, :conference_id], unique: true
    add_index :paper_authors, [:paper_id, :user_id], unique: true
  end
end
