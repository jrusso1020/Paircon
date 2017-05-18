class DeviseCreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: false do |t|
      t.string :user_id, primary_key: true, null: false, limit: 30

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      t.timestamps null: false
    end

    change_table :users do |t|
      t.string :first_name, limit: 20
      t.string :last_name, limit: 20
      t.string :default_lang, default: 'en'
      t.boolean :is_deleted, default: false
      t.boolean :is_active, default: false
      t.boolean :is_app_init, default: false
      t.string :time_zone_name
      t.datetime :last_messages_read
      t.datetime :last_notifications_read
    end

    add_index :users, :user_id,              unique: true
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
  end
end
