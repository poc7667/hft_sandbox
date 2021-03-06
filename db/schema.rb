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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141225073700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cffex_hfts", force: true do |t|
    t.string   "product_type"
    t.datetime "contract_month"
    t.string   "frequence"
    t.datetime "time"
    t.float    "open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.float    "volume"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cffex_hfts", ["product_type", "contract_month", "frequence", "time"], name: "cffex_hfts_index", unique: true, using: :btree

  create_table "cffexes", force: true do |t|
    t.string   "product_type"
    t.datetime "contract_month"
    t.datetime "ticktime"
    t.float    "last_price"
    t.float    "last_volume"
    t.float    "last_total_price"
    t.float    "bid_price"
    t.float    "bid_volume"
    t.float    "ask_price"
    t.float    "ask_volume"
    t.float    "open_interest"
    t.float    "trade_volume"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "czce_hfts", force: true do |t|
    t.string   "product_type"
    t.datetime "contract_month"
    t.string   "frequence"
    t.datetime "time"
    t.float    "open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.float    "volume"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "czce_hfts", ["product_type", "contract_month", "frequence", "time"], name: "czce_hfts_index", unique: true, using: :btree

  create_table "czces", force: true do |t|
    t.string   "product_type"
    t.datetime "ticktime"
    t.float    "last_volume"
    t.float    "last_total_price"
    t.float    "bid_price"
    t.float    "bid_volume"
    t.float    "ask_price"
    t.float    "ask_volume"
    t.float    "open_interest"
    t.float    "trade_volume"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "contract_month"
    t.float    "last_price"
  end

  create_table "data_sources", force: true do |t|
    t.string   "market"
    t.string   "product_type"
    t.datetime "transaction_date"
    t.string   "file_name"
    t.text     "md5_sum"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "data_sources", ["transaction_date", "file_name", "md5_sum"], name: "data_source_index", unique: true, using: :btree

  create_table "queries", force: true do |t|
    t.integer  "user_id"
    t.text     "query_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
