class AddAvatarFileToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :avatar_file, :text
  end
end
