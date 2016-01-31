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

ActiveRecord::Schema.define(version: 20160131210350) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "accounts", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "username",       null: false
    t.string   "provider",       null: false
    t.string   "external_id",    null: false
    t.string   "access_public",  null: false
    t.string   "access_private", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "accounts", ["access_private"], name: "index_accounts_on_access_private", using: :btree
  add_index "accounts", ["access_public"], name: "index_accounts_on_access_public", using: :btree
  add_index "accounts", ["created_at"], name: "index_accounts_on_created_at", using: :btree
  add_index "accounts", ["external_id"], name: "index_accounts_on_external_id", using: :btree
  add_index "accounts", ["provider"], name: "index_accounts_on_provider", using: :btree
  add_index "accounts", ["updated_at"], name: "index_accounts_on_updated_at", using: :btree
  add_index "accounts", ["username", "provider", "external_id", "access_public", "access_private"], name: "index_unique_credentials_on_accounts", unique: true, using: :btree
  add_index "accounts", ["username"], name: "index_accounts_on_username", using: :btree

  create_table "blocks", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "blocks", ["account_id"], name: "index_blocks_on_account_id", using: :btree
  add_index "blocks", ["created_at"], name: "index_blocks_on_created_at", using: :btree
  add_index "blocks", ["updated_at"], name: "index_blocks_on_updated_at", using: :btree

  create_table "connections", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "block_id",   null: false
    t.uuid     "profile_id", null: false
    t.uuid     "trunk_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "connections", ["block_id", "profile_id"], name: "index_connections_on_block_id_and_profile_id", unique: true, using: :btree
  add_index "connections", ["block_id"], name: "index_connections_on_block_id", using: :btree
  add_index "connections", ["created_at"], name: "index_connections_on_created_at", using: :btree
  add_index "connections", ["profile_id"], name: "index_connections_on_profile_id", using: :btree
  add_index "connections", ["trunk_id"], name: "index_connections_on_trunk_id", using: :btree
  add_index "connections", ["updated_at"], name: "index_connections_on_updated_at", using: :btree

  create_table "profiles", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "provider",    null: false
    t.string   "external_id", null: false
    t.string   "username"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "profiles", ["created_at"], name: "index_profiles_on_created_at", using: :btree
  add_index "profiles", ["external_id"], name: "index_profiles_on_external_id", using: :btree
  add_index "profiles", ["provider"], name: "index_profiles_on_provider", using: :btree
  add_index "profiles", ["updated_at"], name: "index_profiles_on_updated_at", using: :btree
  add_index "profiles", ["username"], name: "index_profiles_on_username", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
