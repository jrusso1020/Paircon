class CreateConferences < ActiveRecord::Migration[5.0]
  def change
    create_table :conferences, id: false do |t|
      t.string :conference_id, primary_key: true, null: false, limit: 30
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.text :url
      t.string :location
      t.boolean :pending

      t.timestamps
    end

    add_index :conferences, :conference_id, unique: true
  end
end
