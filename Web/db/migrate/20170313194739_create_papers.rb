class CreatePapers < ActiveRecord::Migration[5.0]
  def change
    create_table :papers, id: false do |t|
      t.string :paper_id, primary_key: true, null: false, limit: 30
      t.string :title
      t.text :pdf_link
      t.string :md5hash
      t.text :path

      t.timestamps
    end

    add_index :papers, :paper_id, unique: true
  end
end
