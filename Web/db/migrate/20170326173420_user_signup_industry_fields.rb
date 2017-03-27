class UserSignupIndustryFields < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_industry, :string, :default => ''
    add_column :users, :user_grad_year, :integer, :limit => 4, :default => 0
    add_column :users, :user_organization, :string, :default => ''
  end
end
