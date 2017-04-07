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

ActiveRecord::Schema.define(version: 20170405223805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "trackable_type"
    t.string   "trackable_id",   limit: 30
    t.string   "owner_type"
    t.string   "owner_id",       limit: 30
    t.string   "key"
    t.text     "parameters"
    t.string   "recipient_type"
    t.string   "recipient_id",   limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  end

  create_table "conference_attendees", force: :cascade do |t|
    t.string   "conference_id", limit: 30
    t.string   "user_id",       limit: 30
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id", "conference_id"], name: "index_conference_attendees_on_user_id_and_conference_id", unique: true, using: :btree
  end

  create_table "conference_organizers", force: :cascade do |t|
    t.string   "conference_id", limit: 30
    t.string   "user_id",       limit: 30
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id", "conference_id"], name: "index_conference_organizers_on_user_id_and_conference_id", unique: true, using: :btree
  end

  create_table "conference_papers", force: :cascade do |t|
    t.string   "paper_id",      limit: 30
    t.string   "conference_id", limit: 30
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["paper_id", "conference_id"], name: "index_conference_papers_on_paper_id_and_conference_id", unique: true, using: :btree
  end

  create_table "conferences", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "url"
    t.string   "location"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "description",        limit: 255, default: ""
    t.string   "domain",             limit: 255, default: ""
    t.boolean  "publish",                        default: false
    t.boolean  "archive",                        default: false
    t.string   "phone",              limit: 255, default: ""
    t.string   "email",              limit: 255, default: ""
  end

  create_table "identities", force: :cascade do |t|
    t.string   "user_id",    limit: 30
    t.string   "provider"
    t.string   "uid"
    t.text     "auth_data"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "organizers", force: :cascade do |t|
    t.string   "user_id"
    t.boolean  "approved",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["user_id"], name: "index_organizers_on_user_id", unique: true, using: :btree
  end

  create_table "papers", force: :cascade do |t|
    t.string   "title"
    t.text     "pdf_link"
    t.string   "md5hash"
    t.text     "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "conference_id", limit: 30
    t.text     "description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["conference_id"], name: "index_posts_on_conference_id", using: :btree
  end

  create_table "similarities", force: :cascade do |t|
    t.string   "paper_id1",        limit: 30
    t.string   "paper_id2",        limit: 30
    t.decimal  "similarity_score"
    t.string   "hash"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["paper_id1", "paper_id2"], name: "index_similarities_on_paper_id1_and_paper_id2", unique: true, using: :btree
  end

  create_table "similarities_indices", force: :cascade do |t|
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                              default: "",    null: false
    t.string   "encrypted_password",                 default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "first_name",              limit: 20
    t.string   "last_name",               limit: 20
    t.string   "default_lang",                       default: "en"
    t.boolean  "is_deleted",                         default: false
    t.boolean  "is_active",                          default: false
    t.boolean  "is_app_init",                        default: false
    t.string   "time_zone_name"
    t.datetime "last_messages_read"
    t.datetime "last_notifications_read"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "phone_number",            limit: 30
    t.integer  "gender",                             default: 1
    t.text     "url"
    t.integer  "user_type",                          default: 0
    t.string   "user_industry",                      default: ""
    t.integer  "user_grad_year"
    t.string   "user_organization",                  default: ""
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
