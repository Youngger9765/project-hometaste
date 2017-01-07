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

ActiveRecord::Schema.define(version: 20170107105359) do

  create_table "big_bun_photos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "big_bun_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.index ["big_bun_id"], name: "index_big_bun_photos_on_big_bun_id", using: :btree
  end

  create_table "big_buns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "restaurant_id",                  null: false
    t.datetime "start_datetime"
    t.datetime "stop_datetime"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "is_public",      default: false
    t.string   "style"
    t.integer  "unit"
    t.time     "prepare_time"
    t.string   "code",                           null: false
  end

  create_table "bulk_buys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "restaurant_id",            null: false
    t.float    "min_order",     limit: 24
    t.time     "cut_off_time"
    t.string   "location"
    t.time     "pick_up_time"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["restaurant_id"], name: "index_bulk_buys_on_restaurant_id", using: :btree
  end

  create_table "cart_bigbuns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "cart_id"
    t.integer  "big_bun_id"
    t.integer  "quantity",   default: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["big_bun_id"], name: "index_cart_bigbuns_on_big_bun_id", using: :btree
    t.index ["cart_id"], name: "index_cart_bigbuns_on_cart_id", using: :btree
  end

  create_table "cart_foods", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "cart_id"
    t.integer  "food_id"
    t.float    "quantity",   limit: 24
    t.decimal  "price",                 precision: 10, scale: 2
    t.decimal  "sub_total",             precision: 10, scale: 2
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.index ["cart_id"], name: "index_cart_foods_on_cart_id", using: :btree
    t.index ["food_id"], name: "index_cart_foods_on_food_id", using: :btree
  end

  create_table "carts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.decimal  "sub_total",                precision: 10, scale: 2
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.float    "delivery_fee",  limit: 24
    t.float    "tax",           limit: 24
    t.float    "tip",           limit: 24
    t.decimal  "total_amount",             precision: 10, scale: 2
    t.index ["restaurant_id"], name: "index_carts_on_restaurant_id", using: :btree
    t.index ["user_id"], name: "index_carts_on_user_id", using: :btree
  end

  create_table "chefs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",        null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.date     "birthday"
    t.string   "SSN"
    t.string   "routing_number"
    t.string   "account_number"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["user_id"], name: "index_chefs_on_user_id", using: :btree
  end

  create_table "cuisines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deliveries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "restaurant_id",                           null: false
    t.float    "min_order",     limit: 24
    t.string   "area"
    t.float    "distance",      limit: 24
    t.decimal  "cost",                     precision: 10
    t.time     "order_hours"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["restaurant_id"], name: "index_deliveries_on_restaurant_id", using: :btree
  end

  create_table "food_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                                 null: false
    t.integer  "food_id",                                 null: false
    t.text     "comment",    limit: 65535,                null: false
    t.float    "score",      limit: 24
    t.boolean  "is_public",                default: true, null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["food_id"], name: "index_food_comments_on_food_id", using: :btree
    t.index ["user_id"], name: "index_food_comments_on_user_id", using: :btree
  end

  create_table "food_photos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "food_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.index ["food_id"], name: "index_food_photos_on_food_id", using: :btree
  end

  create_table "foods", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                                                     default: "",    null: false
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.integer  "restaurant_id"
    t.decimal  "price",                           precision: 10, scale: 2
    t.boolean  "is_public",                                                default: false
    t.text     "about",             limit: 65535
    t.text     "ingredients",       limit: 65535
    t.float    "unit",              limit: 24
    t.string   "unit_name"
    t.float    "max_order",         limit: 24
    t.date     "availability_date"
  end

  create_table "order_food_ships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "order_id"
    t.integer  "food_id"
    t.decimal  "quantity",   precision: 10, scale: 2
    t.decimal  "amount",     precision: 10, scale: 2
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "scheduled_time"
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.string   "customer_name"
    t.string   "shipping_method"
    t.text     "shipping_place",  limit: 65535
    t.string   "shipping_status"
    t.decimal  "amount",                        precision: 10, scale: 2
    t.string   "payment_method"
    t.string   "payment_status",                                         default: "pendeing", null: false
    t.string   "order_status"
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
    t.decimal  "subtotal",                      precision: 10, scale: 2
    t.float    "tip",             limit: 24
    t.float    "delivery_fee",    limit: 24
  end

  create_table "restaurant_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                                    null: false
    t.integer  "restaurant_id",                              null: false
    t.text     "comment",       limit: 65535,                null: false
    t.float    "score",         limit: 24
    t.boolean  "is_public",                   default: true, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["restaurant_id"], name: "index_restaurant_comments_on_restaurant_id", using: :btree
    t.index ["user_id"], name: "index_restaurant_comments_on_user_id", using: :btree
  end

  create_table "restaurant_cuisine_ships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "restaurant_id"
    t.integer  "cuisine_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["cuisine_id"], name: "index_restaurant_cuisine_ships_on_cuisine_id", using: :btree
    t.index ["restaurant_id"], name: "index_restaurant_cuisine_ships_on_restaurant_id", using: :btree
  end

  create_table "restaurant_dish_photos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "restaurant_id"
    t.text     "comment",            limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.index ["restaurant_id"], name: "index_restaurant_dish_photos_on_restaurant_id", using: :btree
  end

  create_table "restaurants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                                        default: "",    null: false
    t.string   "address",                                     default: "",    null: false
    t.string   "phone_number",                                default: "",    null: false
    t.text     "description",                   limit: 65535
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.float    "latitude",                      limit: 24
    t.float    "longitude",                     limit: 24
    t.integer  "chef_id"
    t.boolean  "is_live",                                     default: true
    t.boolean  "is_approved",                                 default: false
    t.string   "city"
    t.string   "state"
    t.integer  "ZIP"
    t.string   "tax_ID"
    t.string   "communication_method"
    t.string   "certificated_num"
    t.string   "certificated_img_file_name"
    t.string   "certificated_img_content_type"
    t.integer  "certificated_img_file_size"
    t.datetime "certificated_img_updated_at"
    t.string   "main_photo_file_name"
    t.string   "main_photo_content_type"
    t.integer  "main_photo_file_size"
    t.datetime "main_photo_updated_at"
    t.integer  "food_comments_count",                         default: 0
    t.float    "food_avg_score",                limit: 24,    default: 0.0
    t.float    "tax",                           limit: 24,    default: 0.0
    t.float    "order_reach",                   limit: 24
    t.index ["ZIP"], name: "index_restaurants_on_ZIP", using: :btree
    t.index ["chef_id"], name: "index_restaurants_on_chef_id", using: :btree
    t.index ["city"], name: "index_restaurants_on_city", using: :btree
    t.index ["is_approved"], name: "index_restaurants_on_is_approved", using: :btree
    t.index ["is_live"], name: "index_restaurants_on_is_live", using: :btree
    t.index ["state"], name: "index_restaurants_on_state", using: :btree
  end

  create_table "user_big_bun_ships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "big_bun_id"
    t.integer  "user_id"
    t.string   "order_id"
    t.string   "usage"
    t.boolean  "is_used",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["big_bun_id"], name: "index_user_big_bun_ships_on_big_bun_id", using: :btree
    t.index ["order_id"], name: "index_user_big_bun_ships_on_order_id", using: :btree
    t.index ["user_id"], name: "index_user_big_bun_ships_on_user_id", using: :btree
  end

  create_table "user_photos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                                default: "",    null: false
    t.string   "encrypted_password",                   default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "name",                                                 null: false
    t.string   "foodie_id",                                            null: false
    t.string   "phone_number",                                         null: false
    t.string   "fb_uid"
    t.string   "fb_token"
    t.text     "fb_raw_data",            limit: 65535
    t.string   "fb_email"
    t.string   "fb_name"
    t.string   "fb_head_shot"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "is_admin",                             default: false
    t.boolean  "is_live",                              default: true
    t.boolean  "is_ban",                               default: false
    t.text     "address",                limit: 65535
    t.string   "google_uid"
    t.string   "google_token"
    t.text     "google_raw_data",        limit: 65535
    t.string   "google_email"
    t.string   "google_name"
    t.string   "google_head_shot"
    t.boolean  "is_chef",                              default: false
    t.string   "gender"
    t.date     "birthday"
    t.string   "ZIP"
    t.string   "last_name"
    t.string   "state"
    t.string   "city"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["fb_uid"], name: "index_users_on_fb_uid", using: :btree
    t.index ["google_uid"], name: "index_users_on_google_uid", using: :btree
    t.index ["is_chef"], name: "index_users_on_is_chef", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
