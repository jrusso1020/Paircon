class SetDefaultsUser < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :user_industry, :string, default: 'N/A'
    change_column :users, :user_organization, :string, default: 'N/A'

    rename_column :users, :user_industry, :industry
    rename_column :users, :user_organization, :organization
    rename_column :users, :user_grad_year, :grad_year
  end
end
