# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110412112041) do

  create_table "portfolios", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hexcolor"
  end

  create_table "stockdatas", :force => true do |t|
    t.date     "d"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stockpost_id"
  end

  add_index "stockdatas", ["stockpost_id"], :name => "index_stockdatas_on_stockpost_id"

  create_table "stockposts", :force => true do |t|
    t.string   "name"
    t.date     "acquired"
    t.integer  "amount"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "portfolio_id"
  end

  add_index "stockposts", ["portfolio_id"], :name => "index_stockposts_on_portfolio_id"

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "active"
    t.datetime "key_timestamp"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

end
