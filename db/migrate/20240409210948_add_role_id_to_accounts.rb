class AddRoleIdToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :role_id, :integer, default: 0
  end
end
