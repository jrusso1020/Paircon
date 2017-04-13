class UpdateAuthorIdToString < ActiveRecord::Migration[5.0]
  def change
    change_column :paper_authors, :id, :string, limit: 30
  end
end
