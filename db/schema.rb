# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_17_035051) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.string "title"
    t.string "payment_amount"
    t.text "notes"
    t.string "location"
    t.bigint "gig_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.time "end_of_appointment"
    t.time "time_of_appointment"
    t.date "date_of_appointment"
    t.boolean "completed", default: false
    t.index ["gig_id"], name: "index_appointments_on_gig_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "company_name"
    t.string "contact_name"
    t.string "email"
    t.string "cell"
    t.string "venmo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
  end

  create_table "gigs", force: :cascade do |t|
    t.string "title"
    t.string "service_type"
    t.bigint "service_id", null: false
    t.bigint "client_id", null: false
    t.text "details"
    t.boolean "completed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_gigs_on_client_id"
    t.index ["service_id"], name: "index_gigs_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "pay_range"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "firstName"
    t.string "lastName"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "username"
  end

  add_foreign_key "appointments", "gigs"
  add_foreign_key "gigs", "clients"
  add_foreign_key "gigs", "services"
  add_foreign_key "services", "users"
end
