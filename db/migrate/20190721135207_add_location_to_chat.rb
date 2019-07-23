class AddLocationToChat < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :latitude, :decimal
    add_column :chats, :longitude, :decimal
    add_index :chats, [:latitude, :longitude]
  end
end
