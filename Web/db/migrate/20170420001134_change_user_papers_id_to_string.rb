class ChangeUserPapersIdToString < ActiveRecord::Migration[5.0]
  def change
    change_column :user_papers, :id, :string
  end
end
