class ChangeDecimalTypesOnUserAndChat < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :latitude, :decimal, :precision => 10, :scale => 10
    change_column :users, :longitude, :decimal, :precision => 10, :scale => 10
    change_column :chats, :latitude, :decimal, :precision => 10, :scale => 10
    change_column :chats, :longitude, :decimal, :precision => 10, :scale => 10
  end
end
