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

ActiveRecord::Schema.define(version: 20150520223134) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "presentations", force: :cascade do |t|
    t.string   "name",       limit: 255,                       null: false
    t.boolean  "published",              default: false,       null: false
    t.integer  "user_id",                                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "theme_id"
    t.string   "folder_zip", limit: 255
    t.string   "type",       limit: 255, default: "Slideshow", null: false
  end

  add_index "presentations", ["theme_id"], name: "index_presentations_on_theme_id"
  add_index "presentations", ["user_id"], name: "index_presentations_on_user_id"

  create_table "slides", force: :cascade do |t|
    t.integer  "slideshow_id",             null: false
    t.string   "image",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "row_order"
  end

  add_index "slides", ["slideshow_id"], name: "index_slides_on_slideshow_id"

  create_table "themes", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "user_id",                 null: false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description", limit: 255
  end

  add_index "themes", ["user_id"], name: "index_themes_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                limit: 255, default: "", null: false
    t.string   "given_name",           limit: 255
    t.string   "family_name",          limit: 255
    t.string   "uid",                  limit: 255
    t.string   "provider",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                             default: 0,  null: false
    t.string   "encrypted_password",   limit: 255, default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",   limit: 255
    t.string   "last_sign_in_ip",      limit: 255
    t.integer  "custom_disk_quota_mb"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
