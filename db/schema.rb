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

ActiveRecord::Schema.define(version: 20151108201758) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_user_streams", force: true do |t|
    t.integer  "data_stream_id"
    t.integer  "admin_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_user_streams", ["admin_user_id"], name: "index_admin_user_streams_on_admin_user_id", using: :btree
  add_index "admin_user_streams", ["data_stream_id"], name: "index_admin_user_streams_on_data_stream_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "researcher",             default: false
    t.boolean  "send_email",             default: false
    t.boolean  "organizer",              default: false
    t.integer  "organization_id"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["organization_id"], name: "index_admin_users_on_organization_id", using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "annotations", force: true do |t|
    t.string  "title"
    t.string  "start"
    t.string  "end"
    t.integer "user_id"
  end

  add_index "annotations", ["user_id"], name: "index_annotations_on_user_id", using: :btree

  create_table "common_surveys", force: true do |t|
  end

  create_table "data_streams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "s_data_streams", force: true do |t|
    t.integer "study_id"
    t.integer "data_stream_id"
  end

  add_index "s_data_streams", ["data_stream_id"], name: "index_s_data_streams_on_data_stream_id", using: :btree
  add_index "s_data_streams", ["study_id"], name: "index_s_data_streams_on_study_id", using: :btree

  create_table "s_surveys", force: true do |t|
    t.integer "survey_id"
    t.integer "study_id"
  end

  add_index "s_surveys", ["study_id"], name: "index_s_surveys_on_study_id", using: :btree
  add_index "s_surveys", ["survey_id"], name: "index_s_surveys_on_survey_id", using: :btree

  create_table "studies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
  end

  add_index "studies", ["organization_id"], name: "index_studies_on_organization_id", using: :btree

  create_table "study_common_surveys", force: true do |t|
    t.integer "common_survey_id"
    t.integer "study_id"
  end

  add_index "study_common_surveys", ["common_survey_id"], name: "index_study_common_surveys_on_common_survey_id", using: :btree
  add_index "study_common_surveys", ["study_id"], name: "index_study_common_surveys_on_study_id", using: :btree

  create_table "study_owners", force: true do |t|
    t.integer  "admin_user_id"
    t.integer  "study_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "study_owners", ["admin_user_id"], name: "index_study_owners_on_admin_user_id", using: :btree
  add_index "study_owners", ["study_id"], name: "index_study_owners_on_study_id", using: :btree

  create_table "study_participants", force: true do |t|
    t.integer  "study_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "study_participants", ["study_id"], name: "index_study_participants_on_study_id", using: :btree
  add_index "study_participants", ["user_id"], name: "index_study_participants_on_user_id", using: :btree

  create_table "study_streams", force: true do |t|
    t.integer  "study_id"
    t.integer  "data_stream_id"
    t.integer  "admin_stream_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "study_streams", ["admin_stream_id"], name: "index_study_streams_on_admin_stream_id", using: :btree
  add_index "study_streams", ["data_stream_id"], name: "index_study_streams_on_data_stream_id", using: :btree
  add_index "study_streams", ["study_id"], name: "index_study_streams_on_study_id", using: :btree

  create_table "surveys", force: true do |t|
    t.string   "name"
    t.string   "version"
    t.string   "description"
    t.text     "definition"
    t.boolean  "public_survey",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public_to_all_users", default: false
    t.string   "search_key_name"
    t.integer  "organization_id"
  end

  add_index "surveys", ["organization_id"], name: "index_surveys_on_organization_id", using: :btree

  create_table "user_streams", force: true do |t|
    t.integer  "user_id"
    t.integer  "data_stream_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_streams", ["data_stream_id"], name: "index_user_streams_on_data_stream_id", using: :btree
  add_index "user_streams", ["user_id"], name: "index_user_streams_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gmail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "organization_id"
  end

  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree

end
