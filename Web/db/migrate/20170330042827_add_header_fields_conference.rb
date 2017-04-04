class AddHeaderFieldsConference < ActiveRecord::Migration[5.0]
  def change
    add_attachment :conferences, :logo
    add_attachment :conferences, :cover
    add_column :conferences, :description, :string, limit: 255, default: ''
    add_column :conferences, :domain, :string, limit: 255, default: ''
    add_column :conferences, :publish, :boolean, default: false
    add_column :conferences, :archive, :boolean, default: false
  end
end
