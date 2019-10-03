class AddBlockTypeToBlockedUser < ActiveRecord::Migration[5.2]
  def change
    add_column :blocked_users, :blocked_type, :integer, :default => 0

    add_index :blocked_users, :blocked_type
  end
end
