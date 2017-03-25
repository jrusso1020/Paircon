class RemovePendingFromConference < ActiveRecord::Migration[5.0]
  def change
    remove_column :conferences, :pending
  end
end
