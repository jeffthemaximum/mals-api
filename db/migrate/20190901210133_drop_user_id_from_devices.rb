class DropUserIdFromDevices < ActiveRecord::Migration[5.2]
  def change
    remove_column :devices, :user_id
  end
end
