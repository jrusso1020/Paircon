class AddUsersIsScraped < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_scraped, :boolean, :default => false
  end
end
