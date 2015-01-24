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

ActiveRecord::Schema.define(version: 20150124104349) do

  create_table "guests", id: false, force: true do |t|
    t.string   "id",           null: false
    t.string   "name",         null: false
    t.boolean  "attendance"
    t.string   "message_url"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_id"
    t.string   "party_id"
    t.integer  "phone_number"
  end

  add_index "guests", ["id"], name: "index_guests_on_id", unique: true

  create_table "parties", id: false, force: true do |t|
    t.string   "id",         null: false
    t.string   "owner",      null: false
    t.datetime "begin_at",   null: false
    t.string   "location",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message"
  end

  add_index "parties", ["id"], name: "index_parties_on_id", unique: true

end
