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

ActiveRecord::Schema.define(:version => 20120830055621) do

  create_table "applicates", :force => true do |t|
    t.string   "user_id"
    t.string   "name"
    t.string   "department"
    t.integer  "number"
    t.string   "reason"
    t.datetime "app_time"
    t.datetime "enabled_time"
    t.integer  "during"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "guest_name"
    t.string   "guest_from"
  end

  create_table "it_cases", :force => true do |t|
    t.string   "user_id"
    t.string   "name"
    t.string   "department"
    t.string   "email"
    t.string   "phone"
    t.string   "location"
    t.string   "cubnum"
    t.text     "description"
    t.string   "casetype"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ipaddress"
    t.string   "status"
    t.datetime "opened_time"
    t.text     "comment"
    t.datetime "closed_time"
    t.integer  "rank"
    t.text     "result"
    t.string   "closer"
    t.string   "creator_id"
    t.string   "created_type"
    t.datetime "begin_time"
  end

  create_table "managements", :force => true do |t|
    t.string   "user"
    t.string   "userid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "department"
  end

  create_table "rights", :force => true do |t|
    t.integer  "management_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tasks", :force => true do |t|
    t.string   "userid"
    t.datetime "taken_date"
    t.string   "it_case_id"
    t.datetime "finished_time"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "upgrades", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.text     "reason"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wirelesses", :force => true do |t|
    t.integer  "applicate_id"
    t.string   "account"
    t.string   "password"
    t.datetime "enabled_time"
    t.datetime "disabled_time"
    t.boolean  "actived",       :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "disabled"
  end

end
