class CreateSimilarities < ActiveRecord::Migration[5.0]
  def change
    create_table :similarities do |t|
      t.integer :paper_id1
      t.integer :paper_id2
      t.decimal :similarity_score
      t.string :hash

      t.timestamps
    end
  end
end
