class UserSignupIndustryFields < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :industry, :string, default: 'N/A'
    add_column :users, :grad_year, :integer, :limit => 4, :default => 0
    add_column :users, :organization, :string, default: 'N/A'
  end
end
