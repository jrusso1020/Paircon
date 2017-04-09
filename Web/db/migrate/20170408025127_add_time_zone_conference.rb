class AddTimeZoneConference < ActiveRecord::Migration[5.0]
  def change
    add_column :conferences, :timezone, :string
  end
end
