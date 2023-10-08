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

ActiveRecord::Schema[7.0].define(version: 2023_10_07_143606) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint("visit_id")
    t.bigint("user_id")
    t.string("name")
    t.jsonb("properties")
    t.datetime("time")
    t.index(["name", "time"], name: "index_ahoy_events_on_name_and_time")
    t.index(["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin)
    t.index(["user_id"], name: "index_ahoy_events_on_user_id")
    t.index(["visit_id"], name: "index_ahoy_events_on_visit_id")
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string("visit_token")
    t.string("visitor_token")
    t.bigint("user_id")
    t.string("ip")
    t.text("user_agent")
    t.text("referrer")
    t.string("referring_domain")
    t.text("landing_page")
    t.string("browser")
    t.string("os")
    t.string("device_type")
    t.string("country")
    t.string("region")
    t.string("city")
    t.float("latitude")
    t.float("longitude")
    t.string("utm_source")
    t.string("utm_medium")
    t.string("utm_term")
    t.string("utm_content")
    t.string("utm_campaign")
    t.string("app_version")
    t.string("os_version")
    t.string("platform")
    t.datetime("started_at")
    t.index(["user_id"], name: "index_ahoy_visits_on_user_id")
    t.index(["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true)
  end

  create_table "ideas", force: :cascade do |t|
    t.string("title")
    t.boolean("is_done", default: false)
    t.bigint("user_id")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["is_done"], name: "index_ideas_on_is_done")
    t.index(["user_id"], name: "index_ideas_on_user_id")
  end

  create_table "invitations", force: :cascade do |t|
    t.string("inviter_type")
    t.bigint("inviter_id")
    t.string("invitee_type")
    t.bigint("invitee_id")
    t.boolean("is_accepted")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["invitee_type", "invitee_id"], name: "index_invitations_on_invitee")
    t.index(["inviter_type", "inviter_id"], name: "index_invitations_on_inviter")
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

  create_table "push_subscriptions", force: :cascade do |t|
    t.string("endpoint")
    t.string("p256dh_key")
    t.string("auth_key")
    t.float("expiration_time")
    t.bigint("user_id")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["user_id"], name: "index_push_subscriptions_on_user_id")
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
