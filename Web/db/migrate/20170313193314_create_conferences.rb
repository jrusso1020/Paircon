class CreateConferences < ActiveRecord::Migration[5.0]
  def change
    create_table :conferences do |t|
      t.string :name
      t.datetime :date
      t.string :location

      t.timestamps
    end
  end
end
