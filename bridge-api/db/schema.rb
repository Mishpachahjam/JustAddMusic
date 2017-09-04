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

ActiveRecord::Schema.define(version: 20170218215525) do

  create_table "bridge_push_notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "message"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "facebook_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "facebook_account_id"
    t.string   "access_token"
    t.string   "picture_url"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "instructor_profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "main_instrument"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "instructor_experience"
    t.string   "bio"
    t.boolean  "is_open_to_jam"
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "lesson_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "is_open"
    t.integer  "student_id"
    t.integer  "instructor_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "starts_at"
    t.string   "lesson_bounty"
    t.string   "lesson_description"
    t.boolean  "is_denied",          default: false
    t.boolean  "is_approved",        default: false
  end

  create_table "lessons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "student_id"
    t.integer  "instructor_id"
    t.datetime "starts_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "message"
    t.boolean  "is_new"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "student_profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "main_instrument"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "playing_level"
    t.string   "bio"
    t.boolean  "is_open_to_jam"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "is_student",      default: false
    t.boolean  "is_instructor",   default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "push_token"
  end

end