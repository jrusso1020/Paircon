class AddContactInfoConference < ActiveRecord::Migration[5.0]
  def change
    add_column :conferences, :phone, :string, limit: 255, default: ''
    add_column :conferences, :email, :string, limit: 255, default: ''
  end
end
