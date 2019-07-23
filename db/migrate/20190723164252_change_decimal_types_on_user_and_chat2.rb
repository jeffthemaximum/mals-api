class ChangeDecimalTypesOnUserAndChat2 < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :latitude, :decimal, :precision => 10, :scale => 6
    change_column :users, :longitude, :decimal, :precision => 10, :scale => 6
    change_column :chats, :latitude, :decimal, :precision => 10, :scale => 6
    change_column :chats, :longitude, :decimal, :precision => 10, :scale => 6
  end
end
