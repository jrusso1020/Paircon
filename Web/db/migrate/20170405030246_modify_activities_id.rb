class ModifyActivitiesId < ActiveRecord::Migration[5.0]
  def up
    change_column :activities, :recipient_id, :string, limit: 30
    change_column :activities, :owner_id, :string, limit: 30
    change_column :activities, :trackable_id, :string, limit: 30
  end

  def down
    change_column :activities, :recipient_id, :integer
    change_column :activities, :owner_id, :integer
    change_column :activities, :trackable_id, :integer
  end
end
