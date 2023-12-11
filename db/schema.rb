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

ActiveRecord::Schema[7.0].define(version: 2023_12_11_124019) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string("name", null: false)
    t.string("record_type", null: false)
    t.bigint("record_id", null: false)
    t.bigint("blob_id", null: false)
    t.datetime("created_at", null: false)
    t.index(["blob_id"], name: "index_active_storage_attachments_on_blob_id")
    t.index(
      ["record_type", "record_id", "name", "blob_id"],
      name: "index_active_storage_attachments_uniqueness",
      unique: true,
    )
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string("key", null: false)
    t.string("filename", null: false)
    t.string("content_type")
    t.text("metadata")
    t.string("service_name", null: false)
    t.bigint("byte_size", null: false)
    t.string("checksum")
    t.datetime("created_at", null: false)
    t.index(["key"], name: "index_active_storage_blobs_on_key", unique: true)
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint("blob_id", null: false)
    t.string("variation_digest", null: false)
    t.index(["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true)
  end

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

  create_table "availabilities", force: :cascade do |t|
    t.bigint("user_id")
    t.date("date")
    t.integer("time_of_day")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["date"], name: "index_availabilities_on_date")
    t.index(["user_id"], name: "index_availabilities_on_user_id")
  end

  create_table "comments", force: :cascade do |t|
    t.string("commentable_type")
    t.bigint("commentable_id")
    t.bigint("author_id")
    t.string("body")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["author_id"], name: "index_comments_on_author_id")
    t.index(["commentable_type", "commentable_id"], name: "index_comments_on_commentable")
  end

  create_table "ideas", force: :cascade do |t|
    t.string("title")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.text("description")
    t.integer("status", default: 0)
    t.bigint("organizer_id")
    t.bigint("thing_id")
    t.datetime("last_activity_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" })
    t.index(["organizer_id"], name: "index_ideas_on_organizer_id")
    t.index(["thing_id"], name: "index_ideas_on_thing_id")
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
    t.bigint("thing_id")
    t.index(["date"], name: "index_meetups_on_date")
    t.index(["is_deleted"], name: "index_meetups_on_is_deleted")
    t.index(["organizer_id"], name: "index_meetups_on_organizer_id")
    t.index(["thing_id"], name: "index_meetups_on_thing_id")
  end

  create_table "memories", force: :cascade do |t|
    t.bigint("meetup_id")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["meetup_id"], name: "index_memories_on_meetup_id")
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
    t.string("identifier")
    t.index(["authenticatable_type", "authenticatable_id"], name: "authenticatable")
    t.index(["identifier"], name: "index_passwordless_sessions_on_identifier", unique: true)
    t.index(["token_digest"], name: "index_passwordless_sessions_on_token_digest")
  end

  create_table "pollable_options", force: :cascade do |t|
    t.string("title")
    t.string("pollable_type")
    t.bigint("pollable_id")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["pollable_type", "pollable_id"], name: "index_pollable_options_on_pollable")
  end

  create_table "public_hashes", force: :cascade do |t|
    t.string("hashable_type")
    t.bigint("hashable_id")
    t.string("value")
    t.datetime("expired_at")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["expired_at"], name: "index_public_hashes_on_expired_at")
    t.index(["hashable_type", "hashable_id"], name: "index_public_hashes_on_hashable")
    t.index(["value"], name: "index_public_hashes_on_value")
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

  create_table "things", force: :cascade do |t|
    t.string("type")
    t.string("title")
    t.string("description")
    t.string("tags")
    t.string("city")
    t.string("url")
    t.string("image_url")
    t.boolean("is_deleted")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.bigint("owner_id")
    t.index(["city"], name: "index_things_on_city")
    t.index(["owner_id"], name: "index_things_on_owner_id")
    t.index(["type"], name: "index_things_on_type")
  end

  create_table "users", force: :cascade do |t|
    t.string("name")
    t.string("email")
    t.string("time_zone")
    t.bigint("inviter_id")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.string("city")
    t.boolean("admin")
    t.index(["email"], name: "index_users_on_email", unique: true)
    t.index(["inviter_id"], name: "index_users_on_inviter_id")
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
