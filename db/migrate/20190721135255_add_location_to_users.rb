class AddLocationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :latitude, :decimal
    add_column :users, :longitude, :decimal
    add_index :users, [:latitude, :longitude]
  end
end
