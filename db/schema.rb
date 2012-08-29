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

ActiveRecord::Schema.define(:version => 20120829032403) do

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

  create_table "admins", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "realname"
    t.string   "permissions"
    t.string   "salt"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
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
    t.decimal  "total_amount", :precision => 10, :scale => 0
    t.integer  "total_orders"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.decimal  "total_amount",  :precision => 10, :scale => 0
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
    t.decimal  "total_sales",         :precision => 10, :scale => 0
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
    t.integer "month"
    t.decimal "total_sales",         :precision => 10, :scale => 0
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
    t.decimal "price",               :precision => 10, :scale => 0
    t.string  "sku_outer_id"
    t.string  "product_name"
    t.decimal "total_fee",           :precision => 10, :scale => 0
    t.decimal "payment",             :precision => 10, :scale => 0
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
    t.decimal  "gross_profit",     :precision => 10, :scale => 0
    t.decimal  "total_fee",        :precision => 10, :scale => 0
    t.decimal  "payment",          :precision => 10, :scale => 0
    t.integer  "platform_id"
    t.string   "user_outer_id"
    t.decimal  "ship_fee",         :precision => 10, :scale => 0
    t.integer  "user_id"
  end

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.string   "login"
    t.string   "password"
    t.string   "salt"
    t.string   "mobile"
    t.string   "tel"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "brand"
    t.string   "company"
    t.string   "intro"
    t.string   "designer_img"
  end

  create_table "product_contents", :force => true do |t|
    t.integer "product_id"
    t.text    "description"
  end

  create_table "product_details", :force => true do |t|
    t.text     "body"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "custom_id"
    t.string   "name"
    t.string   "title"
    t.integer  "num"
    t.integer  "sell_num"
    t.decimal  "price",            :precision => 10, :scale => 0
    t.decimal  "market_price",     :precision => 10, :scale => 0
    t.integer  "status"
    t.string   "header_image_url"
    t.integer  "partner_id"
    t.boolean  "has_invoice"
    t.boolean  "can_maintain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_delete"
    t.integer  "audit_status"
    t.integer  "category_id"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.string   "image4"
    t.string   "image5"
    t.string   "audit_note"
  end

  add_index "products", ["partner_id"], :name => "index_products_on_user_id"

  create_table "properties", :force => true do |t|
    t.integer "product_id"
    t.string  "name"
  end

  add_index "properties", ["product_id"], :name => "index_properties_on_product_id"

  create_table "property_values", :force => true do |t|
    t.integer "property_id"
    t.string  "name"
  end

  add_index "property_values", ["property_id"], :name => "index_property_values_on_property_id"

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
    t.string   "custom_id"
    t.integer  "product_id"
    t.decimal  "price",         :precision => 10, :scale => 0
    t.string   "specification"
    t.integer  "num"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skus", ["product_id"], :name => "index_skus_on_product_id"
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

  create_table "subscribers", :force => true do |t|
    t.string   "email",                                                      :null => false
    t.string   "password",                                                   :null => false
    t.string   "sigil",                                                      :null => false
    t.integer  "initiator_id"
    t.string   "nickname"
    t.string   "mobile"
    t.integer  "region_id"
    t.decimal  "cash",         :precision => 10, :scale => 0, :default => 0, :null => false
    t.decimal  "credit",       :precision => 10, :scale => 0, :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscribers", ["email"], :name => "index_subscribers_on_email", :unique => true
  add_index "subscribers", ["initiator_id"], :name => "index_subscribers_on_initiator_id"
  add_index "subscribers", ["mobile"], :name => "index_subscribers_on_mobile", :unique => true

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
