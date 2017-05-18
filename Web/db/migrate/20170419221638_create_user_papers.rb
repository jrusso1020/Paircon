class CreateUserPapers < ActiveRecord::Migration[5.0]
  def change
    create_table :user_papers, id: false do |t|
      t.string :user_paper_id, primary_key: true, null: false, limit: 30
      t.string :user_id
      t.string :paper_id
    end

    add_index :user_papers, :user_paper_id, unique: true
  end
end
