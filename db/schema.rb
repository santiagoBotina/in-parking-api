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

ActiveRecord::Schema[7.1].define(version: 2024_03_09_050012) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "bank_account_type", ["SAVINGS", "CHECKING"]
  create_enum "legal_id_type", ["CC", "NIT", "PP", "CE", "TI"]
  create_enum "payment_type", ["ONLINE", "CASH"]
  create_enum "reservation_status", ["ACTIVE", "CANCELLED", "MISSED"]
  create_enum "reservation_type", ["ONE_TIME", "WEEKLY", "MONTHLY"]
  create_enum "spot_status", ["AVAILABLE", "RESERVED", "PENDING", "UNAVAILABLE"]
  create_enum "user_account_status", ["ACTIVE", "INACTIVE"]

  create_table "lessors", force: :cascade do |t|
    t.string "legal_name"
    t.enum "legal_id_type", enum_type: "legal_id_type"
    t.string "legal_id"
    t.string "lessor_name"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.string "city"
    t.enum "status", default: "INACTIVE", enum_type: "user_account_status"
    t.enum "bank_account_type", enum_type: "bank_account_type"
    t.string "bank_account_number"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "cognito_id"
    t.string "description"
    t.string "logo"
    t.string "password"
    t.boolean "is_verified", default: false
    t.index ["legal_id"], name: "index_lessors_on_legal_id", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "lessor_id"
    t.integer "reservation_id"
    t.integer "spot_id"
    t.integer "amount_in_cents"
    t.string "status"
    t.enum "payment_type", null: false, enum_type: "payment_type"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "spot_id"
    t.string "vehicle_plate"
    t.enum "reservation_type", enum_type: "reservation_type"
    t.datetime "check_out"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.enum "status", default: "ACTIVE", null: false, enum_type: "reservation_status"
    t.datetime "check_in"
    t.integer "lessor_id"
  end

  create_table "spots", force: :cascade do |t|
    t.integer "lessor_id"
    t.string "address"
    t.string "city"
    t.string "vehicle_type"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.enum "status", null: false, enum_type: "spot_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.enum "legal_id_type", null: false, enum_type: "legal_id_type"
    t.string "legal_id", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "password", null: false
    t.string "status", default: "INACTIVE", null: false
    t.boolean "is_verified", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "cognito_id"
  end

  add_foreign_key "payments", "lessors"
  add_foreign_key "payments", "reservations"
  add_foreign_key "payments", "spots"
  add_foreign_key "payments", "users"
  add_foreign_key "reservations", "lessors"
  add_foreign_key "reservations", "spots"
  add_foreign_key "reservations", "users"
  add_foreign_key "spots", "lessors"
end
