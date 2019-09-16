class AllowEmojisIsReportContent < ActiveRecord::Migration[5.2]
  def change
    # allow emojis
    execute "ALTER TABLE reports CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE reports MODIFY content VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end
end
