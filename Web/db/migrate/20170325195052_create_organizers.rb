class CreateOrganizers < ActiveRecord::Migration[5.0]
  def change
    create_table :organizers do |t|
      t.string :user_id
      t.boolean :pending, :default => true


      t.timestamps
    end
  end
end
