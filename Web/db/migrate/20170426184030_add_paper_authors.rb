class AddPaperAuthors < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :author, :text, array: true, default: []
    add_column :papers, :affiliation, :text, array: true, default: []
    add_column :papers, :email, :text, array: true, default: []
  end
end
