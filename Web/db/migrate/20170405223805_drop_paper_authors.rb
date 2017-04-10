class DropPaperAuthors < ActiveRecord::Migration[5.0]
  def change
    drop_table :paper_authors
  end
end
