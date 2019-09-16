class CreateBlockedUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :blocked_users do |t|
      t.references :user_1, index: true, foreign_key: { to_table: :users }
      t.references :user_2, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
