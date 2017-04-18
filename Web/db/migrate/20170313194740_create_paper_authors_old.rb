class CreatePaperAuthorsOld < ActiveRecord::Migration[5.0]
  def change
    create_table :paper_authors do |t|
      t.integer :paper_id
      t.integer :user_id

      t.timestamps
    end
  end
end
