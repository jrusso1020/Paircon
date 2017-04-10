class AddLatLongConference < ActiveRecord::Migration[5.0]
  def change
    remove_column :conferences, :timezone
    add_column :conferences, :lat, :decimal
    add_column :conferences, :long, :decimal
  end
end
