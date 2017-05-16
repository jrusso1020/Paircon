class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts, id: false do |t|
      t.string :post_id, primary_key: true, null: false, limit: 30
      t.string :conference_id, limit: 30
      t.text :description

      t.timestamps
    end

    add_index :posts, :post_id, unique: true
  end
end
