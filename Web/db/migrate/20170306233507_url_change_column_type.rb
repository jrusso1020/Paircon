class UrlChangeColumnType < ActiveRecord::Migration[5.0]
  def change
    change_column(:users, :url, :text)
  end
end
