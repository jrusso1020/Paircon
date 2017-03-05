class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_attachment :users, :logo

    change_table :users do |t|
      t.string :phone_number, limit: 30
    end
  end
end
