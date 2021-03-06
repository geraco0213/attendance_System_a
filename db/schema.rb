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

ActiveRecord::Schema.define(version: 2022_04_30_210732) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "scheduled_end_time"
    t.string "business_outline"
    t.string "instructor_test"
    t.boolean "tomorrow", default: false
    t.integer "instructor_reply"
    t.boolean "change", default: false
    t.string "instructor_one_month_test"
    t.integer "instructor_one_month_reply"
    t.boolean "change_one_month", default: false
    t.boolean "tomorrow_one_month", default: false
    t.string "instructor_comp_test"
    t.boolean "change_comp", default: false
    t.integer "instructor_comp_reply"
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.date "reply_updated_at"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.string "working_style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.boolean "admin"
    t.string "affiliation"
    t.datetime "basic_work_time", default: "2022-05-26 23:00:00"
    t.datetime "work_time", default: "2022-05-26 22:30:00"
    t.boolean "superior", default: false
    t.datetime "designated_work_start_time", default: "2022-05-27 00:00:00"
    t.datetime "designated_work_end_time", default: "2022-05-27 09:00:00"
    t.integer "employee_number"
    t.string "uid"
  end

  add_foreign_key "attendances", "users"
end
