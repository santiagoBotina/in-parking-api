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

ActiveRecord::Schema[7.1].define(version: 2024_01_21_205225) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "legal_id_type", ["CC", "NIT", "PP", "CE", "TI"]
  create_enum "reservation_status", ["ACTIVE", "CANCELLED", "MISSED"]
  create_enum "reservation_type", ["ONE_TIME", "WEEKLY", "MONTHLY"]

  create_table "reservations", force: :cascade do |t|
    t.integer "user_id"
    t.string "spot_id"
    t.string "vehicle_plate"
    t.enum "reservation_type", enum_type: "reservation_type"
    t.datetime "reserved_until"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.enum "status", default: "ACTIVE", null: false, enum_type: "reservation_status"
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

  add_foreign_key "reservations", "users"
end
