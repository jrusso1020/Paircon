class CreateUserPapers < ActiveRecord::Migration[5.0]
  def change
    create_table :user_papers do |t|
      t.string :user_id
      t.string :paper_id
    end
  end
end
