class FixSimiliarityColumnNames < ActiveRecord::Migration[5.0]
  def change
    rename_column :similarities, :paper_id1, :user_paper_id
    rename_column :similarities, :paper_id2, :conference_paper_id
  end
end
