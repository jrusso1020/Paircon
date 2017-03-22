class CreateConferences < ActiveRecord::Migration[5.0]
  def change
    create_table :conferences do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.text :url
      t.string :location
      t.boolean :pending

      t.timestamps
    end
  end
end
