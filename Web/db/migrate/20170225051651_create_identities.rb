class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities, id: false do |t|
      t.string :identity_id, primary_key: true, null: false, limit: 30
      t.string :user_id, limit: 30
      t.string :provider
      t.string :uid
      t.text :auth_data

      t.timestamps
    end

    add_index :identities, :identity_id, unique: true
  end
end
