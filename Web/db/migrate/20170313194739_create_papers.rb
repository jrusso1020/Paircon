class CreatePapers < ActiveRecord::Migration[5.0]
  def change
    create_table :papers do |t|
      t.string :title
      t.text :pdf_link
      t.string :md5hash
      t.text :path

      t.timestamps
    end
  end
end
