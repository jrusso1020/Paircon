class UpdatePaperAttributes < ActiveRecord::Migration[5.0]
  def change
    remove_column :papers, :author
    remove_column :papers, :year
    add_column :papers, :year, :date
  end
end
