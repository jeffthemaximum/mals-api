class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :notification_type, :null => false
      t.references :user, foreign_key: true, :null => false
      t.references :chat, foreign_key: true, :null => false
      t.index :notification_type

      t.timestamps
    end
  end
end
