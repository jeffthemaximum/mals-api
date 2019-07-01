class AddSentAndDeliveredToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :sent_at, :timestamp
    add_column :messages, :delivered_at, :timestamp
  end
end
