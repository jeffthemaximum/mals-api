# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_31_142149) do

  create_table "chats", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "aasm_state"
    t.datetime "deleted_at"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "join_attempts", default: 0
    t.index ["deleted_at"], name: "index_chats_on_deleted_at"
    t.index ["latitude", "longitude"], name: "index_chats_on_latitude_and_longitude"
  end

  create_table "chats_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chat_id", null: false
    t.index ["user_id", "chat_id"], name: "index_chats_users_on_user_id_and_chat_id"
  end

  create_table "devices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "brand"
    t.string "build_id"
    t.string "build_number"
    t.string "bundle_id"
    t.string "carrier"
    t.string "device"
    t.string "device_country"
    t.string "device_id"
    t.string "device_name"
    t.string "fingerprint"
    t.integer "first_install_time"
    t.string "install_referrer"
    t.string "manufacturer"
    t.string "phone_number"
    t.string "readable_version"
    t.string "serial_number"
    t.string "system_version"
    t.string "timezone"
    t.string "unique_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_accepted_eula", default: false
    t.index ["unique_id"], name: "index_devices_on_unique_id"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.text "text"
    t.bigint "chat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "client_id"
    t.timestamp "sent_at"
    t.timestamp "delivered_at"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "notification_type", null: false
    t.bigint "user_id", null: false
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_notifications_on_chat_id"
    t.index ["notification_type"], name: "index_notifications_on_notification_type"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", limit: 191
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_url"
    t.text "avatar_file"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.boolean "is_admin", default: false
    t.index ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude"
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "devices", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "chats"
  add_foreign_key "notifications", "users"
end
