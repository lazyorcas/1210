# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 2023_09_25_191220) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invites", force: :cascade do |t|
    t.integer("invite_type", default: 0)
    t.boolean("is_accepted")
    t.bigint("inviter_id")
    t.bigint("invitee_id")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["invitee_id"], name: "index_invites_on_invitee_id")
    t.index(["inviter_id"], name: "index_invites_on_inviter_id")
  end

  create_table "meetup_attendances", force: :cascade do |t|
    t.bigint("user_id")
    t.bigint("meetup_id")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["meetup_id"], name: "index_meetup_attendances_on_meetup_id")
    t.index(["user_id"], name: "index_meetup_attendances_on_user_id")
  end

  create_table "meetups", force: :cascade do |t|
    t.string("title")
    t.string("description")
    t.date("date")
    t.string("start_time")
    t.string("end_time")
    t.boolean("is_deleted", default: false)
    t.bigint("organizer_id")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["date"], name: "index_meetups_on_date")
    t.index(["is_deleted"], name: "index_meetups_on_is_deleted")
    t.index(["organizer_id"], name: "index_meetups_on_organizer_id")
  end

  create_table "passwordless_sessions", force: :cascade do |t|
    t.string("authenticatable_type")
    t.bigint("authenticatable_id")
    t.string("token_digest", null: false)
    t.datetime("timeout_at", precision: nil, null: false)
    t.datetime("expires_at", precision: nil, null: false)
    t.datetime("claimed_at", precision: nil)
    t.datetime("created_at", precision: nil, null: false)
    t.datetime("updated_at", precision: nil, null: false)
    t.index(["authenticatable_type", "authenticatable_id"], name: "authenticatable")
    t.index(["token_digest"], name: "index_passwordless_sessions_on_token_digest")
  end

  create_table "users", force: :cascade do |t|
    t.string("name")
    t.string("email")
    t.string("time_zone")
    t.bigint("inviter_id")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["email"], name: "index_users_on_email", unique: true)
    t.index(["inviter_id"], name: "index_users_on_inviter_id")
  end
end
