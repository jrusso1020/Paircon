class DropPdfLinkColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :papers, :pdf_link
  end
end
