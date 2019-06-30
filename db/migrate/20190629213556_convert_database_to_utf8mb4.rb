class ConvertDatabaseToUtf8mb4 < ActiveRecord::Migration[5.2]
  def change
    # for each table that will store unicode execute:
    execute "ALTER TABLE messages CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    # for each string/text column with unicode content execute:
    execute "ALTER TABLE messages MODIFY text VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users MODIFY name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end
end
