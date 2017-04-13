class UpdatePaperAttributes < ActiveRecord::Migration[5.0]
  def change
    remove_column :papers, :author
    change_column :papers, :year, "integer USING NULLIF(year, '')::int"
  end
end
