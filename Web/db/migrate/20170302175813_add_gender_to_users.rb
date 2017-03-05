class AddGenderToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.integer :gender, default: 1
    end
  end
end
