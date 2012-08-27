# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120814102958) do

  create_table "addresses", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "state"
    t.string   "city"
    t.string   "district"
    t.string   "zip"
    t.string   "mobile"
    t.string   "phone"
    t.string   "detail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "customer_id"
    t.string   "loginname"
    t.string   "nickname"
    t.string   "name"
    t.string   "mobile"
    t.string   "phone"
    t.string   "email"
    t.string   "qq"
    t.string   "state"
    t.string   "city"
    t.string   "district"
    t.string   "zip"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "customer_levels", :force => true do |t|
    t.string   "name"
    t.decimal  "total_amount"
    t.integer  "total_orders"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.decimal  "total_amount"
    t.integer  "total_orders"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_outer_id"
    t.integer  "user_id"
    t.integer  "platform_id"
  end

  create_table "day_data", :force => true do |t|
    t.integer  "user_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
    t.decimal  "total_sales"
    t.integer  "total_orders"
    t.integer  "total_products"
    t.integer  "total_customers"
    t.integer  "total_new_customers"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivery_templates", :force => true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "image_url"
    t.integer  "width"
    t.integer  "height"
    t.string   "options"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "template"
    t.string   "fields"
    t.boolean  "default"
  end

  create_table "month_charts", :force => true do |t|
    t.integer "month",               :limit => 255
    t.decimal "total_sales"
    t.integer "total_orders"
    t.integer "total_products"
    t.integer "total_customers"
    t.integer "total_new_customers"
    t.integer "user_id"
    t.integer "year"
  end

  add_index "month_charts", ["user_id"], :name => "index_month_charts_on_user_id"

  create_table "order_items", :force => true do |t|
    t.integer "order_id"
    t.string  "order_outer_id"
    t.integer "product_id"
    t.string  "product_outer_id"
    t.string  "sku_id"
    t.string  "sku_properties_name"
    t.integer "quantity"
    t.decimal "price"
    t.string  "sku_outer_id"
    t.string  "product_name"
    t.decimal "total_fee"
    t.decimal "payment"
    t.string  "image_url"
  end

  create_table "orders", :force => true do |t|
    t.string   "delivery_no"
    t.string   "platform"
    t.string   "name"
    t.string   "destination"
    t.string   "address"
    t.integer  "total"
    t.string   "delivery_company"
    t.string   "delivery_info"
    t.datetime "order_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "outer_id"
    t.string   "buyer_message"
    t.string   "email"
    t.string   "state"
    t.string   "city"
    t.string   "district"
    t.string   "zip"
    t.datetime "consign_time"
    t.string   "mobile"
    t.string   "status"
    t.string   "buyer_nick"
    t.decimal  "gross_profit"
    t.decimal  "total_fee"
    t.decimal  "payment"
    t.integer  "platform_id"
    t.string   "user_outer_id"
    t.decimal  "ship_fee"
    t.integer  "user_id"
  end

  create_table "product_details", :force => true do |t|
    t.text     "body"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "no"
    t.integer  "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price"
    t.integer  "status"
    t.string   "image_url"
    t.string   "detail_url"
    t.string   "outer_id"
    t.integer  "num_iid"
    t.integer  "num"
    t.decimal  "cost_price"
    t.integer  "num_sell"
    t.integer  "platform_id"
    t.string   "outer_custom_id"
    t.integer  "user_id"
  end

  create_table "register_codes", :force => true do |t|
    t.string   "code"
    t.boolean  "is_available"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops", :force => true do |t|
    t.string   "access_token"
    t.string   "shop_name"
    t.string   "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "platform_id"
    t.integer  "user_id"
    t.string   "qq"
    t.string   "top_session"
    t.string   "top_parameters"
    t.string   "spid"
    t.string   "skey"
    t.boolean  "binded"
  end

  create_table "skus", :force => true do |t|
    t.integer  "sku_id"
    t.integer  "product_id"
    t.string   "outer_id"
    t.decimal  "price"
    t.string   "properties"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "platform_quantities"
    t.string   "outer_custom_id"
    t.integer  "user_id"
  end

  add_index "skus", ["user_id"], :name => "index_skus_on_user_id"

  create_table "stocks", :force => true do |t|
    t.integer  "platform_id"
    t.integer  "num"
    t.integer  "min"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sku_id"
  end

  add_index "stocks", ["sku_id"], :name => "index_stocks_on_sku_id"

  create_table "tasks", :force => true do |t|
    t.datetime "delivery_time"
    t.integer  "order_num"
    t.integer  "product_total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_settings", :force => true do |t|
    t.string   "status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "realname"
    t.string   "permissions"
    t.string   "salt"
    t.string   "phone"
    t.string   "register_code"
  end

end
