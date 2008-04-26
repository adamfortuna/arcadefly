# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 117) do

  create_table "addresses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "title"
    t.string   "street",                                       :null => false
    t.string   "city",                                         :null => false
    t.integer  "region_id"
    t.integer  "postal_code",      :limit => 5,                :null => false
    t.integer  "country_id",                    :default => 1
    t.float    "lat"
    t.float    "lng"
    t.float    "public_lat"
    t.float    "public_lng"
  end

  create_table "arcades", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                               :null => false
    t.string   "phone"
    t.string   "website"
    t.text     "notes"
    t.integer  "user_id"
    t.integer  "playables_count",     :default => 0
    t.integer  "frequentships_count", :default => 0
  end

  add_index "arcades", ["name"], :name => "index_arcades_on_name"

  create_table "countries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",         :limit => 80, :null => false
    t.string   "alpha_2_code", :limit => 2,  :null => false
    t.string   "alpha_3_code", :limit => 3,  :null => false
  end

  add_index "countries", ["name"], :name => "index_countries_on_name", :unique => true
  add_index "countries", ["alpha_2_code"], :name => "index_countries_on_alpha_2_code", :unique => true
  add_index "countries", ["alpha_3_code"], :name => "index_countries_on_alpha_3_code", :unique => true

  create_table "favoriteships", :force => true do |t|
    t.integer  "game_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favoriteships", ["user_id", "game_id"], :name => "index_favoriteships_on_user_id_and_game_id", :unique => true

  create_table "frequentships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "arcade_id",  :null => false
    t.integer  "user_id",    :null => false
  end

  add_index "frequentships", ["user_id", "arcade_id"], :name => "index_frequentships_on_user_id_and_arcade_id", :unique => true

  create_table "friendships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "friender_id",                :null => false
    t.integer  "friendee_id",                :null => false
    t.integer  "status",      :default => 0
  end

  add_index "friendships", ["friender_id", "friendee_id"], :name => "index_friendships_on_friender_id_and_friendee_id", :unique => true
  add_index "friendships", ["friendee_id", "friender_id"], :name => "index_friendships_on_friendee_id_and_friender_id", :unique => true

  create_table "games", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                               :null => false
    t.integer  "gamefaqs_id",                        :null => false
    t.integer  "playables_count",     :default => 0
    t.integer  "favoriteships_count", :default => 0
  end

  add_index "games", ["name"], :name => "index_games_on_name", :unique => true
  add_index "games", ["gamefaqs_id"], :name => "index_games_on_gamefaqs_id", :unique => true

  create_table "hours", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timeable_id"
    t.string   "timeable_type"
    t.string   "dayofweek",                       :null => false
    t.integer  "day",                             :null => false
    t.time     "start",                           :null => false
    t.time     "end",                             :null => false
    t.boolean  "closed",        :default => true, :null => false
  end

  add_index "hours", ["timeable_id", "timeable_type", "day"], :name => "index_hours_on_timeable_id_and_timeable_type_and_day", :unique => true

  create_table "playables", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "arcade_id",                  :null => false
    t.integer  "game_id",                    :null => false
    t.integer  "games_count", :default => 1
  end

  add_index "playables", ["arcade_id", "game_id"], :name => "index_playables_on_arcade_id_and_game_id", :unique => true
  add_index "playables", ["arcade_id"], :name => "index_playables_on_arcade_id"
  add_index "playables", ["game_id"], :name => "index_playables_on_game_id"

  create_table "products", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id",                                       :null => false
    t.string   "name"
    t.decimal  "purchase_price", :precision => 10, :scale => 2
    t.decimal  "sale_price",     :precision => 10, :scale => 2
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
  end

  create_table "regions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
    t.string   "name",         :limit => 50, :null => false
    t.string   "abbreviation", :limit => 5,  :null => false
  end

  add_index "regions", ["name", "country_id"], :name => "index_regions_on_name_and_country_id", :unique => true
  add_index "regions", ["abbreviation", "country_id"], :name => "index_regions_on_abbreviation_and_country_id", :unique => true

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",                                                     :null => false
    t.string   "email",                                                     :null => false
    t.string   "name",                                                      :null => false
    t.string   "crypted_password",          :limit => 40
    t.text     "about"
    t.string   "website"
    t.string   "salt",                      :limit => 40
    t.integer  "frequentships_count",                     :default => 0
    t.integer  "favoriteships_count",                     :default => 0
    t.integer  "friendship_count",                        :default => 0
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "password_reset_code",       :limit => 40
    t.boolean  "enabled",                                 :default => true
    t.boolean  "administrator",                           :default => true, :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["login", "crypted_password"], :name => "index_users_on_login_and_crypted_password"

end
