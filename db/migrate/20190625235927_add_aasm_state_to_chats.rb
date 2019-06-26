class AddAasmStateToChats < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :aasm_state, :string
  end
end
