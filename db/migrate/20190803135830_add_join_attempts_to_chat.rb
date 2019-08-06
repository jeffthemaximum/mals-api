class AddJoinAttemptsToChat < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :join_attempts, :integer, :default => 0
  end
end
