class AddColToPapers < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :author, :string
    add_column :papers, :keywords, :text
    add_column :papers, :year, :string
  end
end
