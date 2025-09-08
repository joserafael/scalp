# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_08_212507) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cryptocurrencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "symbol", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_cryptocurrencies_on_active"
    t.index ["name"], name: "index_cryptocurrencies_on_name", unique: true
    t.index ["symbol"], name: "index_cryptocurrencies_on_symbol", unique: true
  end

  create_table "trade_pairs", force: :cascade do |t|
    t.bigint "buy_trade_id", null: false
    t.bigint "sell_trade_id", null: false
    t.decimal "profit", precision: 15, scale: 8, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buy_trade_id"], name: "index_trade_pairs_on_buy_trade_id"
    t.index ["profit"], name: "index_trade_pairs_on_profit"
    t.index ["sell_trade_id"], name: "index_trade_pairs_on_sell_trade_id"
  end

  create_table "trades", force: :cascade do |t|
    t.bigint "cryptocurrency_id", null: false
    t.string "operation_type", null: false
    t.decimal "total_value", precision: 15, scale: 8, null: false
    t.decimal "unit_price", precision: 15, scale: 8, null: false
    t.decimal "quantity", precision: 15, scale: 8, null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["cryptocurrency_id", "operation_type", "status"], name: "idx_on_cryptocurrency_id_operation_type_status_cac4822ae8"
    t.index ["cryptocurrency_id"], name: "index_trades_on_cryptocurrency_id"
    t.index ["operation_type"], name: "index_trades_on_operation_type"
    t.index ["status"], name: "index_trades_on_status"
    t.index ["user_id"], name: "index_trades_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "trade_pairs", "trades", column: "buy_trade_id"
  add_foreign_key "trade_pairs", "trades", column: "sell_trade_id"
  add_foreign_key "trades", "cryptocurrencies"
  add_foreign_key "trades", "users"
end
