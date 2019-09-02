class CreateJoinTableDevicesUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :devices, :users do |t|
      # t.index [:device_id, :user_id]
      t.index [:user_id, :device_id]
    end
  end
end
