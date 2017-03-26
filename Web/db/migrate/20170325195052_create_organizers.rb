class CreateOrganizers < ActiveRecord::Migration[5.0]
  def change
    create_table :organizers do |t|
      t.string :user_id
      t.boolean :approved, :default => false


      t.timestamps
    end
  end
end
