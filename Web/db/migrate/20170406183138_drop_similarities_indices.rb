class DropSimilaritiesIndices < ActiveRecord::Migration[5.0]
  def change
    drop_table :similarities_indices
  end
end
