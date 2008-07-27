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

ActiveRecord::Schema.define(:version => 18) do

  create_table "addresses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "title"
    t.string   "street"
    t.string   "city",                                         :null => false
    t.integer  "region_id"
    t.integer  "postal_code",      :limit => 8
    t.integer  "country_id",                    :default => 1, :null => false
    t.float    "lat"
    t.float    "lng"
    t.float    "public_lat"
    t.float    "public_lng"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addressable_id_and_addressable_type"

  create_table "arcades", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                               :null => false
    t.string   "permalink",                          :null => false
    t.string   "phone"
    t.string   "website"
    t.text     "notes"
    t.integer  "profile_id"
    t.integer  "playables_count",     :default => 0
    t.integer  "frequentships_count", :default => 0
  end

  add_index "arcades", ["permalink"], :name => "index_arcades_on_permalink", :unique => true
  add_index "arcades", ["name"], :name => "index_arcades_on_name"

  create_table "comments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "comment"
    t.integer  "is_denied",        :default => 0,     :null => false
    t.boolean  "is_reviewed",      :default => false
  end

  add_index "comments", ["profile_id"], :name => "index_comments_on_profile_id"
  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

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
    t.integer  "profile_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favoriteships", ["profile_id", "game_id"], :name => "index_favoriteships_on_profile_id_and_game_id", :unique => true
  add_index "favoriteships", ["profile_id"], :name => "index_favoriteships_on_profile_id"
  add_index "favoriteships", ["game_id"], :name => "index_favoriteships_on_game_id"

  create_table "frequentships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "arcade_id",  :null => false
    t.integer  "profile_id", :null => false
  end

  add_index "frequentships", ["profile_id", "arcade_id"], :name => "index_frequentships_on_profile_id_and_arcade_id", :unique => true
  add_index "frequentships", ["profile_id"], :name => "index_frequentships_on_profile_id"
  add_index "frequentships", ["arcade_id"], :name => "index_frequentships_on_arcade_id"

  create_table "friends", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inviter_id",                :null => false
    t.integer  "invited_id",                :null => false
    t.integer  "status",     :default => 0
  end

  add_index "friends", ["inviter_id", "invited_id"], :name => "index_friends_on_inviter_id_and_invited_id", :unique => true

  create_table "games", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                               :null => false
    t.integer  "gamefaqs_id",                        :null => false
    t.string   "permalink",                          :null => false
    t.integer  "playables_count",     :default => 0
    t.integer  "favoriteships_count", :default => 0
  end

  add_index "games", ["name"], :name => "index_games_on_name", :unique => true
  add_index "games", ["gamefaqs_id"], :name => "index_games_on_gamefaqs_id", :unique => true
  add_index "games", ["permalink"], :name => "index_games_on_permalink", :unique => true

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

  create_table "messages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.text     "body"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.boolean  "read",        :default => false, :null => false
  end

  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"
  add_index "messages", ["receiver_id"], :name => "index_messages_on_receiver_id"

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

  create_table "profiles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "active",                :default => false, :null => false
    t.boolean  "administrator",         :default => false, :null => false
    t.string   "email",                                    :null => false
    t.string   "display_name",                             :null => false
    t.string   "permalink",                                :null => false
    t.string   "initials"
    t.string   "full_name"
    t.string   "website"
    t.text     "about_me"
    t.string   "aim_name"
    t.string   "gtalk_name"
    t.string   "msn_name"
    t.integer  "frequentships_count",   :default => 0
    t.integer  "favoriteships_count",   :default => 0
    t.integer  "friendships_count",     :default => 0
    t.integer  "messages_count",        :default => 0,     :null => false
    t.integer  "unread_messages_count", :default => 0,     :null => false
  end

  add_index "profiles", ["permalink"], :name => "index_profiles_on_permalink", :unique => true
  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"
  add_index "profiles", ["email"], :name => "index_profiles_on_email"
  add_index "profiles", ["display_name"], :name => "index_profiles_on_display_name"

  create_table "regions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
    t.string   "name",         :limit => 50, :null => false
    t.string   "abbreviation", :limit => 5,  :null => false
  end

  add_index "regions", ["name", "country_id"], :name => "index_regions_on_name_and_country_id", :unique => true
  add_index "regions", ["abbreviation", "country_id"], :name => "index_regions_on_abbreviation_and_country_id", :unique => true

  create_table "sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_id"
    t.text     "data"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                                      :null => false
    t.string   "new_email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "password_reset_code",       :limit => 40
    t.boolean  "enabled",                                 :default => true
    t.boolean  "administrator",                           :default => false, :null => false
    t.boolean  "can_send_messages",                       :default => true
    t.string   "time_zone",                               :default => "UTC"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["email", "crypted_password"], :name => "index_users_on_email_and_crypted_password"

end
