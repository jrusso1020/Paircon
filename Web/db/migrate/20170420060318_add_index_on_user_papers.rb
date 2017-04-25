class AddIndexOnUserPapers < ActiveRecord::Migration[5.0]
  def change
    add_index :user_papers, [:paper_id, :user_id], unique: true
  end
end
