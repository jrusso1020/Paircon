class CreateSimilarities < ActiveRecord::Migration[5.0]
  def change
    create_table :similarities, id: false do |t|
      t.string :similarity_id, primary_key: true, null: false, limit: 30
      t.string :paper_id1, limit: 30
      t.string :paper_id2, limit: 30
      t.decimal :similarity_score
      t.string :hash

      t.timestamps
    end

    add_index :similarities, :similarity_id, unique: true

  end
end
