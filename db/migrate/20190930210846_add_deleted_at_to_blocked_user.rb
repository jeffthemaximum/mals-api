class AddDeletedAtToBlockedUser < ActiveRecord::Migration[5.2]
  def change
    add_column :blocked_users, :deleted_at, :datetime
    add_index :blocked_users, :deleted_at
  end
end
