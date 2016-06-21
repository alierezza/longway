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

ActiveRecord::Schema.define(version: 20160621021622) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ads", force: :cascade do |t|
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.string   "session"
    t.string   "name"
    t.float    "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "boards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "detailreportarticles", force: :cascade do |t|
    t.integer  "detailreport_id"
    t.string   "article"
    t.integer  "operator"
    t.integer  "output",          default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "detailreports", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "opr",             default: 0
    t.integer  "target",          default: 0
    t.integer  "act",             default: 0
    t.float    "percent",         default: 0.0
    t.float    "pph",             default: 0.0
    t.integer  "defect_int",      default: 0
    t.integer  "defect_ext",      default: 0
    t.float    "rft",             default: 0.0
    t.text     "remark"
    t.integer  "jam"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "article"
    t.string   "po"
    t.string   "mfg"
    t.integer  "defect_int_11b",  default: 0
    t.integer  "defect_int_11c",  default: 0
    t.integer  "defect_int_11j",  default: 0
    t.integer  "defect_int_11l",  default: 0
    t.integer  "defect_int_13d",  default: 0
    t.integer  "defect_ext_bs3",  default: 0
    t.integer  "defect_ext_bs7",  default: 0
    t.integer  "defect_ext_bs13", default: 0
    t.integer  "defect_ext_bs15", default: 0
    t.integer  "defect_ext_bs17", default: 0
    t.string   "country",                       null: false
    t.string   "category",                      null: false
  end

  add_index "detailreports", ["report_id", "jam"], name: "index_detailreports_on_report_id_and_jam", unique: true, using: :btree

  create_table "homes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.boolean  "status",              default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
  end

  create_table "languages", force: :cascade do |t|
    t.text     "message"
    t.text     "description"
    t.text     "foreign_language"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "lines", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "nama"
    t.integer  "no"
    t.boolean  "status",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "visible",    default: true
  end

  create_table "masteremails", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problems", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "line_id"
    t.date     "tanggal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reports", ["line_id", "tanggal"], name: "index_reports_on_line_id_and_tanggal", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "",     null: false
    t.string   "encrypted_password",                default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "nama"
    t.text     "alamat"
    t.string   "telp"
    t.string   "role",                              default: "User"
    t.boolean  "status",                            default: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "unique_session_id",      limit: 20
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
