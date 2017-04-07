class UserSignupGradyearDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :user_grad_year, :integer, :limit => 4, :default => ''
  end
end
