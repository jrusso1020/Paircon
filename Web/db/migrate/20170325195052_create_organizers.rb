class CreateOrganizers < ActiveRecord::Migration[5.0]
  def change
    create_table :organizers, id: false do |t|
      t.string :organizer_id, primary_key: true, null: false, limit: 30
      t.string :user_id, limit: 30
      t.boolean :approved, :default => false

      t.timestamps
    end

    add_index :organizers, :organizer_id, unique: true

  end
end
