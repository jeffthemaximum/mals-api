class AddClientIdToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :client_id, :string
  end
end
