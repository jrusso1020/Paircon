class CreatePaperAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :paper_authors do |t|
      t.string :name
      t.string :affiliation
      t.string :paper_id

      t.timestamps
    end
  end
end
