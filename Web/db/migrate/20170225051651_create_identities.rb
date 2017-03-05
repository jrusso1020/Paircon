class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.string :user_id, limit: 30
      t.string :provider
      t.string :uid
      t.text :auth_data

      t.timestamps
    end

  end
end
