class AddTypeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :type, :integer, default: 0
  end
end
