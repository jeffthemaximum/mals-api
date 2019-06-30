class AddDeletedAtToChats < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :deleted_at, :datetime
    add_index :chats, :deleted_at
  end
end
