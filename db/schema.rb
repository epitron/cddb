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

ActiveRecord::Schema.define(:version => 20090921221646) do

  create_table "nodes", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lent_to_id"
    t.string   "type"
    t.text     "comment"
    t.string   "disc_path"
    t.integer  "crate_id"
    t.integer  "sleeve_id"
    t.integer  "size"
    t.datetime "date"
  end

end
