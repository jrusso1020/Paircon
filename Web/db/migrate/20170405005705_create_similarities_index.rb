class CreateSimilaritiesIndex < ActiveRecord::Migration[5.0]
  def change
    create_table :similarities_indices do |t|
      add_index :similarities, [:paper_id1, :paper_id2], unique: true
    end
  end
end
