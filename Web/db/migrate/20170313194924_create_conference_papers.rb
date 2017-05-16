class CreateConferencePapers < ActiveRecord::Migration[5.0]
  def change
    create_table :conference_papers, id: false do |t|
      t.string :conference_paper_id, primary_key: true, null: false, limit: 30
      t.string :paper_id, limit: 30
      t.string :conference_id, limit: 30

      t.timestamps
    end

    add_index :conference_papers, :conference_paper_id, unique: true
  end
end
