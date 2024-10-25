class AddPendingApprovalToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :pending_approval, :boolean, default: true
  end
end
