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

ActiveRecord::Schema.define(version: 20170228173110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "cart_products", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_products_on_cart_id", using: :btree
    t.index ["product_id"], name: "index_cart_products_on_product_id", using: :btree
  end

  create_table "carts", force: :cascade do |t|
    t.string   "gender"
    t.integer  "price"
    t.string   "name"
    t.string   "tags",       default: [], null: false, array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "price"
    t.integer  "product_id"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id", using: :btree
    t.index ["product_id"], name: "index_order_items_on_product_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.date     "delivery_date"
    t.string   "address"
    t.string   "status"
    t.json     "payment"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "cost"
    t.integer  "total_price_cents", default: 0, null: false
    t.string   "phone"
<<<<<<< HEAD
    t.integer  "total_price_cents", default: 0, null: false
=======
>>>>>>> master
    t.string   "company"
  end

  create_table "product_lists", force: :cascade do |t|
    t.jsonb    "filtered_catalog"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "session_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "brand"
    t.string   "name"
    t.text     "description"
    t.string   "description_short"
    t.string   "image"
    t.string   "tag_one"
    t.string   "tag_two"
    t.integer  "sell_priority"
    t.string   "gender"
    t.boolean  "online_supplied"
    t.integer  "stock"
    t.boolean  "availability"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "supplier_name"
    t.integer  "price_cents",       default: 0, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "cart_products", "products"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
end
