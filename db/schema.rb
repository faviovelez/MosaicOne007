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

ActiveRecord::Schema.define(version: 20170606235623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "documents", force: :cascade do |t|
    t.string   "document"
    t.integer  "request_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "document_type"
  end

  add_index "documents", ["request_id"], name: "index_documents_on_request_id", using: :btree

  create_table "modified_fields", force: :cascade do |t|
    t.string   "field"
    t.integer  "request_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "modified_fields", ["request_id"], name: "index_modified_fields_on_request_id", using: :btree
  add_index "modified_fields", ["user_id"], name: "index_modified_fields_on_user_id", using: :btree

  create_table "prospects", force: :cascade do |t|
    t.string   "name"
    t.integer  "store_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "prospect_type"
  end

  add_index "prospects", ["store_id"], name: "index_prospects_on_store_id", using: :btree

  create_table "requests", force: :cascade do |t|
    t.string   "product_type"
    t.string   "product_what"
    t.float    "product_length"
    t.float    "product_width"
    t.float    "product_height"
    t.float    "product_weight"
    t.string   "for_what"
    t.integer  "boxes_stow"
    t.integer  "quantity"
    t.float    "inner_length"
    t.float    "inner_width"
    t.string   "inner_height"
    t.float    "outer_length"
    t.float    "outer_widht"
    t.float    "outer_height"
    t.float    "bag_length"
    t.float    "bag_width"
    t.float    "bag_height"
    t.float    "sheet_length"
    t.float    "sheet_height"
    t.string   "main_material"
    t.string   "resistance_main_material"
    t.string   "secondary_material"
    t.string   "resistance_secondary_material"
    t.string   "third_material"
    t.string   "resistance_third_material"
    t.string   "impression"
    t.integer  "inks"
    t.string   "impression_finishing"
    t.string   "which_finishing"
    t.date     "delivery_date"
    t.float    "maximum_sales_price"
    t.text     "observations"
    t.text     "notes"
    t.integer  "prospect_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "product_code"
    t.integer  "final_quantity"
    t.boolean  "require_dummy"
    t.boolean  "require_printcard"
    t.boolean  "printcard_authorised"
    t.boolean  "dummy_generated"
    t.boolean  "dummy_authorised"
    t.boolean  "printcard_generated"
    t.boolean  "payment_uploaded"
    t.boolean  "authorisation_signed"
    t.date     "date_finished"
    t.float    "internal_cost"
    t.float    "internal_price"
    t.float    "sales_price"
    t.string   "impression_type"
    t.string   "impression_where"
    t.float    "dummy_cost"
    t.float    "design_cost"
    t.string   "design_like"
    t.string   "resistance_like"
    t.string   "rigid_color"
    t.string   "paper_type_rigid"
    t.string   "main_material_color"
    t.string   "secondary_material_color"
    t.string   "third_material_color"
  end

  add_index "requests", ["prospect_id"], name: "index_requests_on_prospect_id", using: :btree

  create_table "stores", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "store_type"
  end

  add_index "stores", ["user_id"], name: "index_stores_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "views", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "views", ["email"], name: "index_views_on_email", unique: true, using: :btree
  add_index "views", ["reset_password_token"], name: "index_views_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "documents", "requests"
  add_foreign_key "modified_fields", "requests"
  add_foreign_key "modified_fields", "users"
  add_foreign_key "prospects", "stores"
  add_foreign_key "requests", "prospects"
  add_foreign_key "stores", "users"
end
