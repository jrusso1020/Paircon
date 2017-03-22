class CreateConferencePapers < ActiveRecord::Migration[5.0]
  def change
    create_table :conference_papers do |t|
      t.integer :paper_id
      t.integer :conference_id

      t.timestamps
    end
  end
end
