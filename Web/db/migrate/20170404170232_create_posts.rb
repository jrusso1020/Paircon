class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :conference_id, limit: 30
      t.text :description

      t.timestamps
    end

    change_column :posts, :id, :string, limit: 30
  end
end
