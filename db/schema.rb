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

ActiveRecord::Schema.define(version: 2020_12_16_122555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
  end

  create_table "leads", force: :cascade do |t|
    t.string "project_name"
    t.string "client_name"
    t.string "client_address"
    t.string "client_email"
    t.string "client_contact"
    t.string "platform_used"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_sale", default: false
    t.index ["user_id"], name: "index_leads_on_user_id"
  end

  create_table "phases", force: :cascade do |t|
    t.string "phase_type"
    t.string "assignee"
    t.datetime "start_date"
    t.datetime "due_date"
    t.bigint "lead_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_complete", default: false
    t.index ["lead_id"], name: "index_phases_on_lead_id"
  end

  create_table "phases_users", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "phase_id"
    t.index ["phase_id"], name: "index_phases_users_on_phase_id"
    t.index ["user_id"], name: "index_phases_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.integer "role"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "leads", "users"
  add_foreign_key "phases", "leads"
  add_foreign_key "phases_users", "phases"
  add_foreign_key "phases_users", "users"
end
