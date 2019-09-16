class AddUserToReport < ActiveRecord::Migration[5.2]
  def change
    add_reference :reports, :user, foreign_key: true
  end
end
