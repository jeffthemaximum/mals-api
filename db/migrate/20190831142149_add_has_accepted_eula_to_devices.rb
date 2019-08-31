class AddHasAcceptedEulaToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :has_accepted_eula, :boolean, :default => false
  end
end
