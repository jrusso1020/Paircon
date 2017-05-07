class RenameSimilarityHash < ActiveRecord::Migration[5.0]
  def change
    rename_column :similarities, :hash, :md5hash
  end
end
