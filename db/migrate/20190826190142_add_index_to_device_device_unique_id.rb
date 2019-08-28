class AddIndexToDeviceDeviceUniqueId < ActiveRecord::Migration[5.2]
  def change
    add_index :devices, :unique_id
  end
end
