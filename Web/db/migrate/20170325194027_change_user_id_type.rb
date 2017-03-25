class ChangeUserIdType < ActiveRecord::Migration[5.0]
  def change
    change_column :conference_attendees, :user_id, :string
    change_column :conference_organizers, :user_id, :string
    change_column :paper_authors, :user_id, :string
  end
end
