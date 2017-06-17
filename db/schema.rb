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

ActiveRecord::Schema.define(version: 20170617043302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "additional_discounts", force: :cascade do |t|
    t.string   "type_of_discount"
    t.float    "percentage"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "bill_id"
  end

  add_index "additional_discounts", ["bill_id"], name: "index_additional_discounts_on_bill_id", using: :btree

  create_table "billing_addresses", force: :cascade do |t|
    t.string   "type_of_person"
    t.string   "business_name"
    t.string   "rfc"
    t.string   "street"
    t.string   "exterior_number"
    t.string   "interior_number"
    t.integer  "zipcode"
    t.string   "neighborhood"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "type_of_bill"
    t.string   "bill_for_who"
    t.string   "classification"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "bills", force: :cascade do |t|
    t.string   "status"
    t.integer  "product_catalog_id"
    t.integer  "order_id"
    t.float    "initial_price"
    t.float    "discount_applied"
    t.float    "additional_discount_applied"
    t.float    "price_before_taxes"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "bills", ["order_id"], name: "index_bills_on_order_id", using: :btree
  add_index "bills", ["product_catalog_id"], name: "index_bills_on_product_catalog_id", using: :btree

  create_table "carriers", force: :cascade do |t|
    t.string   "name"
    t.string   "street"
    t.string   "exterior_number"
    t.string   "interior_number"
    t.string   "zipcode"
    t.string   "neighborhood"
    t.text     "additional_references"
    t.integer  "order_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "carriers", ["order_id"], name: "index_carriers_on_order_id", using: :btree

  create_table "delivery_addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "exterior_number"
    t.string   "interior_number"
    t.string   "zipcode"
    t.string   "neighborhood"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "additional_references"
    t.integer  "prospect_id"
    t.string   "type_of_address"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "delivery_addresses", ["prospect_id"], name: "index_delivery_addresses_on_prospect_id", using: :btree

  create_table "delivery_packages", force: :cascade do |t|
    t.float    "lenght"
    t.float    "width"
    t.float    "height"
    t.float    "weight"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "delivery_packages", ["order_id"], name: "index_delivery_packages_on_order_id", using: :btree

  create_table "design_requests", force: :cascade do |t|
    t.string   "design_type"
    t.float    "cost"
    t.string   "status"
    t.boolean  "authorisation"
    t.string   "attachment"
    t.string   "outcome"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "request_id"
    t.text     "description"
  end

  add_index "design_requests", ["request_id"], name: "index_design_requests_on_request_id", using: :btree

  create_table "designers", force: :cascade do |t|
    t.string   "username"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "designers", ["user_id"], name: "index_designers_on_user_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "document"
    t.integer  "request_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "document_type"
    t.integer  "design_request_id"
  end

  add_index "documents", ["design_request_id"], name: "index_documents_on_design_request_id", using: :btree
  add_index "documents", ["request_id"], name: "index_documents_on_request_id", using: :btree

  create_table "frequencies", force: :cascade do |t|
    t.string   "category"
    t.integer  "times_ordered"
    t.integer  "order_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "image"
    t.integer  "product_catalog_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "images", ["product_catalog_id"], name: "index_images_on_product_catalog_id", using: :btree

  create_table "managers", force: :cascade do |t|
    t.string   "username"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "managers", ["user_id"], name: "index_managers_on_user_id", using: :btree

  create_table "modified_fields", force: :cascade do |t|
    t.string   "field"
    t.integer  "request_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "modified_fields", ["request_id"], name: "index_modified_fields_on_request_id", using: :btree
  add_index "modified_fields", ["user_id"], name: "index_modified_fields_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "status"
    t.integer  "user_id"
    t.integer  "delivery_address_id"
    t.integer  "additional_discount_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "category"
    t.integer  "times_ordered"
  end

  add_index "orders", ["additional_discount_id"], name: "index_orders_on_additional_discount_id", using: :btree
  add_index "orders", ["delivery_address_id"], name: "index_orders_on_delivery_address_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "product_catalogs", force: :cascade do |t|
    t.string   "former_code"
    t.string   "unique_code"
    t.string   "description"
    t.string   "product_type"
    t.string   "exterior_material_color"
    t.string   "interior_material_color"
    t.boolean  "impression"
    t.string   "exterior_color_or_design"
    t.string   "main_material"
    t.string   "resistance_main_material"
    t.float    "inner_length"
    t.float    "inner_width"
    t.float    "inner_height"
    t.float    "outer_length"
    t.float    "outer_width"
    t.float    "outer_height"
    t.string   "design_type"
    t.integer  "number_of_pieces"
    t.string   "accesories_kit"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.float    "price"
  end

  create_table "productions", force: :cascade do |t|
    t.string   "status"
    t.integer  "user_id"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "productions", ["order_id"], name: "index_productions_on_order_id", using: :btree
  add_index "productions", ["user_id"], name: "index_productions_on_user_id", using: :btree

  create_table "prospects", force: :cascade do |t|
    t.integer  "store_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "prospect_type"
    t.string   "contact_first_name"
    t.string   "contact_middle_name"
    t.string   "contact_last_name"
    t.string   "contact_position"
    t.string   "direct_phone"
    t.string   "extension"
    t.string   "cell_phone"
    t.string   "business_type"
    t.string   "prospect_status"
    t.float    "discount"
    t.string   "legal_or_business_name"
  end

  add_index "prospects", ["store_id"], name: "index_prospects_on_store_id", using: :btree

  create_table "request_users", force: :cascade do |t|
    t.integer  "request_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "request_users", ["request_id"], name: "index_request_users_on_request_id", using: :btree
  add_index "request_users", ["user_id"], name: "index_request_users_on_user_id", using: :btree

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
    t.boolean  "payment_uploaded"
    t.boolean  "authorisation_signed"
    t.date     "date_finished"
    t.float    "internal_cost"
    t.float    "internal_price"
    t.float    "sales_price"
    t.string   "impression_type"
    t.string   "impression_where"
    t.string   "design_like"
    t.string   "resistance_like"
    t.string   "rigid_color"
    t.string   "paper_type_rigid"
    t.integer  "store_id"
    t.boolean  "require_design"
    t.string   "exterior_material_color"
    t.string   "interior_material_color"
    t.string   "other_material_color"
    t.string   "store_code"
    t.string   "store_name"
    t.integer  "order_id"
    t.string   "status"
    t.integer  "manager_id"
    t.integer  "designer_id"
  end

  add_index "requests", ["designer_id"], name: "index_requests_on_designer_id", using: :btree
  add_index "requests", ["manager_id"], name: "index_requests_on_manager_id", using: :btree
  add_index "requests", ["order_id"], name: "index_requests_on_order_id", using: :btree
  add_index "requests", ["prospect_id"], name: "index_requests_on_prospect_id", using: :btree
  add_index "requests", ["store_id"], name: "index_requests_on_store_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  add_index "roles", ["user_id"], name: "index_roles_on_user_id", using: :btree

  create_table "stores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "store_type"
    t.string   "store_code"
    t.string   "store_name"
    t.string   "group"
    t.float    "discount"
  end

  create_table "user_requests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "request_id"
  end

  add_index "user_requests", ["request_id"], name: "index_user_requests_on_request_id", using: :btree
  add_index "user_requests", ["user_id"], name: "index_user_requests_on_user_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

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
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "store_id"
    t.integer  "role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree
  add_index "users", ["store_id"], name: "index_users_on_store_id", using: :btree

  add_foreign_key "additional_discounts", "bills"
  add_foreign_key "bills", "orders"
  add_foreign_key "bills", "product_catalogs"
  add_foreign_key "carriers", "orders"
  add_foreign_key "delivery_addresses", "prospects"
  add_foreign_key "delivery_packages", "orders"
  add_foreign_key "design_requests", "requests"
  add_foreign_key "designers", "users"
  add_foreign_key "documents", "design_requests"
  add_foreign_key "documents", "requests"
  add_foreign_key "images", "product_catalogs"
  add_foreign_key "managers", "users"
  add_foreign_key "modified_fields", "requests"
  add_foreign_key "modified_fields", "users"
  add_foreign_key "orders", "additional_discounts"
  add_foreign_key "orders", "delivery_addresses"
  add_foreign_key "orders", "users"
  add_foreign_key "productions", "orders"
  add_foreign_key "productions", "users"
  add_foreign_key "prospects", "stores"
  add_foreign_key "request_users", "requests"
  add_foreign_key "request_users", "users"
  add_foreign_key "requests", "designers"
  add_foreign_key "requests", "managers"
  add_foreign_key "requests", "orders"
  add_foreign_key "requests", "prospects"
  add_foreign_key "requests", "stores"
  add_foreign_key "roles", "users"
  add_foreign_key "user_requests", "requests"
  add_foreign_key "user_requests", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "stores"
end
