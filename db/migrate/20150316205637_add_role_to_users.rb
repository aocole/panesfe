class AddRoleToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :role, :string
    add_column :users, :role, :integer, :null => false, :default => 0
  end
end
