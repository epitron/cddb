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

ActiveRecord::Schema.define(:version => 20090923144706) do

  create_table "nodes", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.string   "type"
    t.integer  "lent_to_id"
    t.text     "comment"
    t.string   "disc_path"
    t.integer  "crate_id"
    t.integer  "sleeve_id"
    t.integer  "size"
    t.datetime "date"
  end

  add_index "nodes", ["lent_to_id"], :name => "index_nodes_on_lent_to_id"
  add_index "nodes", ["name"], :name => "index_nodes_on_name"
  add_index "nodes", ["parent_id"], :name => "index_nodes_on_parent_id"
  add_index "nodes", ["type"], :name => "index_nodes_on_type"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
