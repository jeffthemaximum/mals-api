class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :brand
      t.string :build_id
      t.string :build_number
      t.string :bundle_id
      t.string :carrier
      t.string :device
      t.string :device_country
      t.string :device_id
      t.string :device_name
      t.string :fingerprint
      t.integer :first_install_time
      t.string :install_referrer
      t.string :manufacturer
      t.string :phone_number
      t.string :readable_version
      t.string :serial_number
      t.string :system_version
      t.string :timezone
      t.string :unique_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
