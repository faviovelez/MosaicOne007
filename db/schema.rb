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

ActiveRecord::Schema.define(version: 20170916190999) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "additional_discounts", force: :cascade do |t|
    t.string   "type_of_discount"
    t.float    "percentage"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "bill_receiveds", force: :cascade do |t|
    t.string   "folio"
    t.date     "date_of_bill"
    t.float    "subtotal"
    t.float    "taxes_rate"
    t.float    "taxes"
    t.float    "total_amount"
    t.integer  "supplier_id"
    t.integer  "product_id"
    t.date     "payment_day"
    t.boolean  "payment_complete"
    t.boolean  "payment_on_time"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "business_unit_id"
    t.integer  "store_id"
  end

  add_index "bill_receiveds", ["business_unit_id"], name: "index_bill_receiveds_on_business_unit_id", using: :btree
  add_index "bill_receiveds", ["product_id"], name: "index_bill_receiveds_on_product_id", using: :btree
  add_index "bill_receiveds", ["store_id"], name: "index_bill_receiveds_on_store_id", using: :btree
  add_index "bill_receiveds", ["supplier_id"], name: "index_bill_receiveds_on_supplier_id", using: :btree

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
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "bills", force: :cascade do |t|
    t.string   "status"
    t.integer  "order_id"
    t.float    "initial_price"
    t.float    "discount_applied"
    t.float    "additional_discount_applied"
    t.float    "price_before_taxes"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "type_of_bill"
    t.integer  "prospect_id"
    t.string   "classification"
    t.float    "amount"
    t.integer  "quantity"
    t.string   "pdf"
    t.string   "xml"
    t.integer  "issuing_company_id"
    t.integer  "receiving_company_id"
    t.integer  "business_unit_id"
    t.integer  "store_id"
    t.string   "sequence"
    t.string   "folio"
    t.integer  "expedition_zip_id"
    t.integer  "payment_condition_id"
    t.integer  "payment_method_id"
    t.integer  "payment_form_id"
    t.integer  "tax_regime_id"
    t.integer  "cfdi_use_id"
    t.integer  "tax_id"
    t.integer  "pac_id"
    t.string   "fiscal_folio"
    t.string   "digital_stamp"
    t.string   "sat_stamp"
    t.string   "original_chain"
    t.integer  "relation_type_id"
    t.integer  "child_bills_id"
    t.integer  "parent_id"
    t.string   "references_field"
    t.integer  "type_of_bill_id"
  end

  add_index "bills", ["business_unit_id"], name: "index_bills_on_business_unit_id", using: :btree
  add_index "bills", ["cfdi_use_id"], name: "index_bills_on_cfdi_use_id", using: :btree
  add_index "bills", ["child_bills_id"], name: "index_bills_on_child_bills_id", using: :btree
  add_index "bills", ["expedition_zip_id"], name: "index_bills_on_expedition_zip_id", using: :btree
  add_index "bills", ["issuing_company_id"], name: "index_bills_on_issuing_company_id", using: :btree
  add_index "bills", ["order_id"], name: "index_bills_on_order_id", using: :btree
  add_index "bills", ["pac_id"], name: "index_bills_on_pac_id", using: :btree
  add_index "bills", ["parent_id"], name: "index_bills_on_parent_id", using: :btree
  add_index "bills", ["payment_condition_id"], name: "index_bills_on_payment_condition_id", using: :btree
  add_index "bills", ["payment_form_id"], name: "index_bills_on_payment_form_id", using: :btree
  add_index "bills", ["payment_method_id"], name: "index_bills_on_payment_method_id", using: :btree
  add_index "bills", ["prospect_id"], name: "index_bills_on_prospect_id", using: :btree
  add_index "bills", ["receiving_company_id"], name: "index_bills_on_receiving_company_id", using: :btree
  add_index "bills", ["relation_type_id"], name: "index_bills_on_relation_type_id", using: :btree
  add_index "bills", ["store_id"], name: "index_bills_on_store_id", using: :btree
  add_index "bills", ["tax_id"], name: "index_bills_on_tax_id", using: :btree
  add_index "bills", ["tax_regime_id"], name: "index_bills_on_tax_regime_id", using: :btree
  add_index "bills", ["type_of_bill_id"], name: "index_bills_on_type_of_bill_id", using: :btree

  create_table "business_group_sales", force: :cascade do |t|
    t.integer  "business_group_id"
    t.integer  "month"
    t.integer  "year"
    t.float    "sales_amount"
    t.string   "sales_quantity"
    t.string   "integer"
    t.float    "cost"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "business_group_sales", ["business_group_id"], name: "index_business_group_sales_on_business_group_id", using: :btree

  create_table "business_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "business_group_type"
  end

  create_table "business_groups_suppliers", force: :cascade do |t|
    t.integer  "business_group_id"
    t.integer  "supplier_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "business_groups_suppliers", ["business_group_id"], name: "index_business_groups_suppliers_on_business_group_id", using: :btree
  add_index "business_groups_suppliers", ["supplier_id"], name: "index_business_groups_suppliers_on_supplier_id", using: :btree

  create_table "business_unit_sales", force: :cascade do |t|
    t.integer  "business_unit_id"
    t.float    "sales_amount"
    t.integer  "sales_quantity"
    t.float    "cost"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "month"
    t.integer  "year"
  end

  add_index "business_unit_sales", ["business_unit_id"], name: "index_business_unit_sales_on_business_unit_id", using: :btree

  create_table "business_units", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "business_group_id"
    t.integer  "billing_address_id"
  end

  add_index "business_units", ["billing_address_id"], name: "index_business_units_on_billing_address_id", using: :btree
  add_index "business_units", ["business_group_id"], name: "index_business_units_on_business_group_id", using: :btree

  create_table "carriers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "delivery_address_id"
  end

  add_index "carriers", ["delivery_address_id"], name: "index_carriers_on_delivery_address_id", using: :btree

  create_table "cfdi_uses", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "cost_types", force: :cascade do |t|
    t.string   "warehouse_cost_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "description"
  end

  create_table "delivery_addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "exterior_number"
    t.string   "interior_number"
    t.string   "zipcode"
    t.string   "neighborhood"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "type_of_address"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "additional_references"
    t.string   "name"
  end

  create_table "delivery_attempts", force: :cascade do |t|
    t.integer  "product_request_id"
    t.integer  "order_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "movement_id"
  end

  add_index "delivery_attempts", ["movement_id"], name: "index_delivery_attempts_on_movement_id", using: :btree
  add_index "delivery_attempts", ["order_id"], name: "index_delivery_attempts_on_order_id", using: :btree
  add_index "delivery_attempts", ["product_request_id"], name: "index_delivery_attempts_on_product_request_id", using: :btree

  create_table "delivery_packages", force: :cascade do |t|
    t.float    "length"
    t.float    "width"
    t.float    "height"
    t.float    "weight"
    t.integer  "order_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "delivery_attempt_id"
  end

  add_index "delivery_packages", ["delivery_attempt_id"], name: "index_delivery_packages_on_delivery_attempt_id", using: :btree
  add_index "delivery_packages", ["order_id"], name: "index_delivery_packages_on_order_id", using: :btree

  create_table "design_costs", force: :cascade do |t|
    t.string   "complexity"
    t.float    "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "design_request_users", force: :cascade do |t|
    t.integer "design_request_id"
    t.integer "user_id"
  end

  add_index "design_request_users", ["design_request_id"], name: "index_design_request_users_on_design_request_id", using: :btree
  add_index "design_request_users", ["user_id"], name: "index_design_request_users_on_user_id", using: :btree

  create_table "design_requests", force: :cascade do |t|
    t.string   "design_type"
    t.float    "cost"
    t.string   "status"
    t.boolean  "authorisation"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "request_id"
    t.text     "description"
    t.string   "attachment"
    t.text     "notes"
  end

  add_index "design_requests", ["request_id"], name: "index_design_requests_on_request_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "request_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "document_type"
    t.integer  "design_request_id"
    t.string   "document"
  end

  add_index "documents", ["design_request_id"], name: "index_documents_on_design_request_id", using: :btree
  add_index "documents", ["request_id"], name: "index_documents_on_request_id", using: :btree

  create_table "expedition_zips", force: :cascade do |t|
    t.integer  "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.float    "subtotal"
    t.float    "taxes_rate"
    t.float    "total"
    t.integer  "store_id"
    t.integer  "business_unit_id"
    t.integer  "user_id"
    t.integer  "bill_received_id"
    t.integer  "month"
    t.integer  "year"
    t.date     "expense_date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "expenses", ["bill_received_id"], name: "index_expenses_on_bill_received_id", using: :btree
  add_index "expenses", ["business_unit_id"], name: "index_expenses_on_business_unit_id", using: :btree
  add_index "expenses", ["store_id"], name: "index_expenses_on_store_id", using: :btree
  add_index "expenses", ["user_id"], name: "index_expenses_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "product_id"
  end

  add_index "images", ["product_id"], name: "index_images_on_product_id", using: :btree

  create_table "inventories", force: :cascade do |t|
    t.integer  "product_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "quantity",    default: 0
    t.string   "unique_code"
    t.boolean  "alert"
  end

  add_index "inventories", ["product_id"], name: "index_inventories_on_product_id", using: :btree

  create_table "inventory_configurations", force: :cascade do |t|
    t.integer  "business_unit_id"
    t.float    "reorder_point",       default: 0.5
    t.float    "critical_point",      default: 0.25
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "months_in_inventory", default: 3
    t.integer  "store_id"
  end

  add_index "inventory_configurations", ["business_unit_id"], name: "index_inventory_configurations_on_business_unit_id", using: :btree
  add_index "inventory_configurations", ["store_id"], name: "index_inventory_configurations_on_store_id", using: :btree

  create_table "movements", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.string   "movement_type"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "order_id"
    t.integer  "user_id"
    t.float    "cost"
    t.string   "unique_code"
    t.integer  "store_id"
    t.float    "initial_price"
    t.integer  "supplier_id"
    t.integer  "business_unit_id"
    t.integer  "prospect_id"
    t.integer  "bill_id"
    t.integer  "product_request_id"
    t.date     "maximum_date"
    t.integer  "delivery_package_id"
    t.boolean  "confirm",             default: false
    t.float    "discount_applied"
    t.float    "final_price"
  end

  add_index "movements", ["bill_id"], name: "index_movements_on_bill_id", using: :btree
  add_index "movements", ["business_unit_id"], name: "index_movements_on_business_unit_id", using: :btree
  add_index "movements", ["delivery_package_id"], name: "index_movements_on_delivery_package_id", using: :btree
  add_index "movements", ["order_id"], name: "index_movements_on_order_id", using: :btree
  add_index "movements", ["product_id"], name: "index_movements_on_product_id", using: :btree
  add_index "movements", ["product_request_id"], name: "index_movements_on_product_request_id", using: :btree
  add_index "movements", ["prospect_id"], name: "index_movements_on_prospect_id", using: :btree
  add_index "movements", ["store_id"], name: "index_movements_on_store_id", using: :btree
  add_index "movements", ["supplier_id"], name: "index_movements_on_supplier_id", using: :btree
  add_index "movements", ["user_id"], name: "index_movements_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "status"
    t.integer  "delivery_address_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "category"
    t.integer  "prospect_id"
    t.integer  "request_id"
    t.integer  "billing_address_id"
    t.integer  "carrier_id"
    t.integer  "store_id"
    t.boolean  "confirm"
    t.text     "delivery_notes"
  end

  add_index "orders", ["billing_address_id"], name: "index_orders_on_billing_address_id", using: :btree
  add_index "orders", ["carrier_id"], name: "index_orders_on_carrier_id", using: :btree
  add_index "orders", ["delivery_address_id"], name: "index_orders_on_delivery_address_id", using: :btree
  add_index "orders", ["prospect_id"], name: "index_orders_on_prospect_id", using: :btree
  add_index "orders", ["request_id"], name: "index_orders_on_request_id", using: :btree
  add_index "orders", ["store_id"], name: "index_orders_on_store_id", using: :btree

  create_table "orders_users", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "orders_users", ["order_id"], name: "index_orders_users_on_order_id", using: :btree
  add_index "orders_users", ["user_id"], name: "index_orders_users_on_user_id", using: :btree

  create_table "pacs", force: :cascade do |t|
    t.string   "name"
    t.string   "certificate"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "payment_conditions", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "payment_forms", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "payments", force: :cascade do |t|
    t.date     "payment_date"
    t.float    "amount"
    t.integer  "bill_received_id"
    t.integer  "supplier_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "payments", ["bill_received_id"], name: "index_payments_on_bill_received_id", using: :btree
  add_index "payments", ["supplier_id"], name: "index_payments_on_supplier_id", using: :btree

  create_table "pending_movements", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "order_id"
    t.float    "cost"
    t.string   "unique_code"
    t.integer  "store_id"
    t.float    "initial_price"
    t.integer  "supplier_id"
    t.string   "movement_type"
    t.integer  "user_id"
    t.integer  "business_unit_id"
    t.integer  "prospect_id"
    t.integer  "bill_id"
    t.integer  "product_request_id"
    t.date     "maximum_date"
    t.float    "discount_applied"
    t.float    "final_price"
  end

  add_index "pending_movements", ["bill_id"], name: "index_pending_movements_on_bill_id", using: :btree
  add_index "pending_movements", ["business_unit_id"], name: "index_pending_movements_on_business_unit_id", using: :btree
  add_index "pending_movements", ["order_id"], name: "index_pending_movements_on_order_id", using: :btree
  add_index "pending_movements", ["product_id"], name: "index_pending_movements_on_product_id", using: :btree
  add_index "pending_movements", ["product_request_id"], name: "index_pending_movements_on_product_request_id", using: :btree
  add_index "pending_movements", ["prospect_id"], name: "index_pending_movements_on_prospect_id", using: :btree
  add_index "pending_movements", ["store_id"], name: "index_pending_movements_on_store_id", using: :btree
  add_index "pending_movements", ["supplier_id"], name: "index_pending_movements_on_supplier_id", using: :btree
  add_index "pending_movements", ["user_id"], name: "index_pending_movements_on_user_id", using: :btree

  create_table "product_requests", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.string   "status"
    t.integer  "order_id"
    t.string   "urgency_level"
    t.date     "maximum_date"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "delivery_package_id"
    t.boolean  "armed"
  end

  add_index "product_requests", ["delivery_package_id"], name: "index_product_requests_on_delivery_package_id", using: :btree
  add_index "product_requests", ["order_id"], name: "index_product_requests_on_order_id", using: :btree
  add_index "product_requests", ["product_id"], name: "index_product_requests_on_product_id", using: :btree

  create_table "product_sales", force: :cascade do |t|
    t.float    "sales_amount"
    t.integer  "sales_quantity"
    t.float    "cost"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "product_id"
    t.integer  "month"
    t.integer  "year"
  end

  add_index "product_sales", ["product_id"], name: "index_product_sales_on_product_id", using: :btree

  create_table "production_orders", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status"
  end

  add_index "production_orders", ["user_id"], name: "index_production_orders_on_user_id", using: :btree

  create_table "production_requests", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.string   "status"
    t.integer  "production_order_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "production_requests", ["product_id"], name: "index_production_requests_on_product_id", using: :btree
  add_index "production_requests", ["production_order_id"], name: "index_production_requests_on_production_order_id", using: :btree

  create_table "products", force: :cascade do |t|
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
    t.integer  "number_of_pieces",         default: 1
    t.string   "accesories_kit",           default: "ninguno"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.float    "price"
    t.float    "bag_length"
    t.float    "bag_width"
    t.float    "bag_height"
    t.float    "exhibitor_height"
    t.integer  "tray_quantity"
    t.float    "tray_length"
    t.float    "tray_width"
    t.integer  "tray_divisions"
    t.string   "classification"
    t.string   "line"
    t.string   "image"
    t.integer  "pieces_per_package",       default: 1
    t.integer  "business_unit_id"
    t.integer  "warehouse_id"
    t.float    "cost"
    t.string   "rack"
    t.string   "level"
    t.integer  "unit_id"
    t.integer  "sat_key_id"
    t.integer  "sat_unit_key_id"
  end

  add_index "products", ["business_unit_id"], name: "index_products_on_business_unit_id", using: :btree
  add_index "products", ["sat_key_id"], name: "index_products_on_sat_key_id", using: :btree
  add_index "products", ["sat_unit_key_id"], name: "index_products_on_sat_unit_key_id", using: :btree
  add_index "products", ["unit_id"], name: "index_products_on_unit_id", using: :btree
  add_index "products", ["warehouse_id"], name: "index_products_on_warehouse_id", using: :btree

  create_table "products_bills", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "bill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "products_bills", ["bill_id"], name: "index_products_bills_on_bill_id", using: :btree
  add_index "products_bills", ["product_id"], name: "index_products_bills_on_product_id", using: :btree

  create_table "prospect_sales", force: :cascade do |t|
    t.integer  "prospect_id"
    t.float    "sales_amount"
    t.integer  "sales_quantity"
    t.float    "cost"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "month"
    t.integer  "year"
  end

  add_index "prospect_sales", ["prospect_id"], name: "index_prospect_sales_on_prospect_id", using: :btree

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
    t.string   "legal_or_business_name"
    t.integer  "billing_address_id"
    t.integer  "delivery_address_id"
    t.string   "second_last_name"
    t.integer  "business_unit_id"
    t.string   "email"
    t.integer  "business_group_id"
    t.string   "store_code"
  end

  add_index "prospects", ["billing_address_id"], name: "index_prospects_on_billing_address_id", using: :btree
  add_index "prospects", ["business_group_id"], name: "index_prospects_on_business_group_id", using: :btree
  add_index "prospects", ["business_unit_id"], name: "index_prospects_on_business_unit_id", using: :btree
  add_index "prospects", ["delivery_address_id"], name: "index_prospects_on_delivery_address_id", using: :btree
  add_index "prospects", ["store_id"], name: "index_prospects_on_store_id", using: :btree

  create_table "relation_types", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

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
    t.integer  "quantity"
    t.float    "inner_length"
    t.float    "inner_width"
    t.string   "inner_height"
    t.float    "outer_length"
    t.float    "outer_width"
    t.float    "outer_height"
    t.float    "bag_length"
    t.float    "bag_width"
    t.float    "bag_height"
    t.string   "main_material"
    t.string   "resistance_main_material"
    t.string   "secondary_material"
    t.string   "resistance_secondary_material"
    t.string   "third_material"
    t.string   "resistance_third_material"
    t.string   "impression"
    t.integer  "inks"
    t.string   "impression_finishing"
    t.date     "delivery_date"
    t.float    "maximum_sales_price"
    t.text     "observations"
    t.text     "notes"
    t.integer  "prospect_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "final_quantity"
    t.boolean  "payment_uploaded"
    t.boolean  "authorisation_signed"
    t.date     "date_finished"
    t.float    "internal_cost"
    t.float    "internal_price"
    t.float    "sales_price"
    t.string   "impression_where"
    t.string   "design_like"
    t.string   "resistance_like"
    t.string   "rigid_color"
    t.string   "paper_type_rigid"
    t.integer  "store_id"
    t.boolean  "require_design"
    t.string   "exterior_material_color"
    t.string   "interior_material_color"
    t.string   "status"
    t.float    "exhibitor_height"
    t.integer  "tray_quantity"
    t.float    "tray_length"
    t.float    "tray_width"
    t.integer  "tray_divisions"
    t.string   "name_type"
    t.boolean  "contraencolado"
    t.boolean  "authorised_without_doc"
    t.string   "how_many"
    t.boolean  "authorised_without_pay"
    t.string   "boxes_stow"
    t.string   "specification"
    t.string   "what_measures"
    t.boolean  "specification_document"
    t.boolean  "sensitive_fields_changed"
    t.string   "payment"
    t.string   "authorisation"
    t.boolean  "authorised"
    t.string   "last_status"
    t.integer  "product_id"
  end

  add_index "requests", ["product_id"], name: "index_requests_on_product_id", using: :btree
  add_index "requests", ["prospect_id"], name: "index_requests_on_prospect_id", using: :btree
  add_index "requests", ["store_id"], name: "index_requests_on_store_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "translation"
  end

  create_table "sak_keys", force: :cascade do |t|
    t.string   "sat_key"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sat_keys", force: :cascade do |t|
    t.string   "sat_key"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sat_unit_keys", force: :cascade do |t|
    t.string   "unit"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "store_sales", force: :cascade do |t|
    t.integer  "store_id"
    t.string   "month"
    t.string   "year"
    t.float    "sales_amount"
    t.integer  "sales_quantity"
    t.float    "cost"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "store_sales", ["store_id"], name: "index_store_sales_on_store_id", using: :btree

  create_table "store_types", force: :cascade do |t|
    t.string   "store_type"
    t.integer  "business_unit_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "store_types", ["business_unit_id"], name: "index_store_types_on_business_unit_id", using: :btree

  create_table "stores", force: :cascade do |t|
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "store_code"
    t.string   "store_name"
    t.float    "discount"
    t.integer  "delivery_address_id"
    t.integer  "business_unit_id"
    t.integer  "store_type_id"
    t.string   "email"
    t.integer  "cost_type_id"
    t.date     "cost_type_selected_since"
    t.integer  "months_in_inventory",      default: 3
    t.float    "reorder_point",            default: 50.0
    t.float    "critical_point",           default: 25.0
    t.string   "contact_first_name"
    t.string   "contact_middle_name"
    t.string   "contact_last_name"
    t.string   "direct_phone"
    t.string   "extension"
    t.string   "type_of_person"
    t.string   "second_last_name"
    t.integer  "business_group_id"
    t.string   "cell_phone"
    t.integer  "billing_address_id"
  end

  add_index "stores", ["billing_address_id"], name: "index_stores_on_billing_address_id", using: :btree
  add_index "stores", ["business_group_id"], name: "index_stores_on_business_group_id", using: :btree
  add_index "stores", ["business_unit_id"], name: "index_stores_on_business_unit_id", using: :btree
  add_index "stores", ["cost_type_id"], name: "index_stores_on_cost_type_id", using: :btree
  add_index "stores", ["delivery_address_id"], name: "index_stores_on_delivery_address_id", using: :btree
  add_index "stores", ["store_type_id"], name: "index_stores_on_store_type_id", using: :btree

  create_table "suppliers", force: :cascade do |t|
    t.string   "name"
    t.string   "business_type"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "type_of_person"
    t.string   "contact_first_name"
    t.string   "contact_middle_name"
    t.string   "contact_last_name"
    t.string   "contact_position"
    t.string   "direct_phone"
    t.string   "extension"
    t.string   "cell_phone"
    t.string   "email"
    t.string   "supplier_status"
    t.integer  "delivery_address_id"
    t.date     "last_purchase_bill_date"
    t.string   "last_purhcase_folio"
    t.integer  "store_id"
  end

  add_index "suppliers", ["delivery_address_id"], name: "index_suppliers_on_delivery_address_id", using: :btree
  add_index "suppliers", ["store_id"], name: "index_suppliers_on_store_id", using: :btree

  create_table "tax_regimes", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "taxes", force: :cascade do |t|
    t.string   "description"
    t.float    "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "type_of_bills", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "units", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_requests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "request_id"
  end

  add_index "user_requests", ["request_id"], name: "index_user_requests_on_request_id", using: :btree
  add_index "user_requests", ["user_id"], name: "index_user_requests_on_user_id", using: :btree

  create_table "user_sales", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "month"
    t.string   "year"
    t.float    "sales_amount"
    t.integer  "sales_quantity"
    t.float    "cost"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "user_sales", ["user_id"], name: "index_user_sales_on_user_id", using: :btree

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

  create_table "warehouse_entries", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "entry_number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "movement_id"
  end

  add_index "warehouse_entries", ["movement_id"], name: "index_warehouse_entries_on_movement_id", using: :btree
  add_index "warehouse_entries", ["product_id"], name: "index_warehouse_entries_on_product_id", using: :btree

  create_table "warehouses", force: :cascade do |t|
    t.string   "name"
    t.integer  "delivery_address_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "business_unit_id"
    t.integer  "store_id"
    t.string   "warehouse_code"
    t.integer  "business_group_id"
  end

  add_index "warehouses", ["business_group_id"], name: "index_warehouses_on_business_group_id", using: :btree
  add_index "warehouses", ["business_unit_id"], name: "index_warehouses_on_business_unit_id", using: :btree
  add_index "warehouses", ["delivery_address_id"], name: "index_warehouses_on_delivery_address_id", using: :btree
  add_index "warehouses", ["store_id"], name: "index_warehouses_on_store_id", using: :btree

  add_foreign_key "bill_receiveds", "business_units"
  add_foreign_key "bill_receiveds", "products"
  add_foreign_key "bill_receiveds", "stores"
  add_foreign_key "bill_receiveds", "suppliers"
  add_foreign_key "bills", "business_units"
  add_foreign_key "bills", "cfdi_uses"
  add_foreign_key "bills", "expedition_zips"
  add_foreign_key "bills", "orders"
  add_foreign_key "bills", "pacs"
  add_foreign_key "bills", "payment_conditions"
  add_foreign_key "bills", "payment_forms"
  add_foreign_key "bills", "payment_methods"
  add_foreign_key "bills", "prospects"
  add_foreign_key "bills", "relation_types"
  add_foreign_key "bills", "stores"
  add_foreign_key "bills", "tax_regimes"
  add_foreign_key "bills", "taxes"
  add_foreign_key "bills", "type_of_bills"
  add_foreign_key "business_group_sales", "business_groups"
  add_foreign_key "business_groups_suppliers", "business_groups"
  add_foreign_key "business_groups_suppliers", "suppliers"
  add_foreign_key "business_unit_sales", "business_units"
  add_foreign_key "business_units", "billing_addresses"
  add_foreign_key "business_units", "business_groups"
  add_foreign_key "carriers", "delivery_addresses"
  add_foreign_key "delivery_attempts", "movements"
  add_foreign_key "delivery_attempts", "orders"
  add_foreign_key "delivery_attempts", "product_requests"
  add_foreign_key "delivery_packages", "delivery_attempts"
  add_foreign_key "delivery_packages", "orders"
  add_foreign_key "design_request_users", "design_requests"
  add_foreign_key "design_request_users", "users"
  add_foreign_key "design_requests", "requests"
  add_foreign_key "documents", "design_requests"
  add_foreign_key "documents", "requests"
  add_foreign_key "expenses", "bill_receiveds"
  add_foreign_key "expenses", "business_units"
  add_foreign_key "expenses", "stores"
  add_foreign_key "expenses", "users"
  add_foreign_key "images", "products"
  add_foreign_key "inventories", "products"
  add_foreign_key "inventory_configurations", "business_units"
  add_foreign_key "inventory_configurations", "stores"
  add_foreign_key "movements", "bills"
  add_foreign_key "movements", "business_units"
  add_foreign_key "movements", "delivery_packages"
  add_foreign_key "movements", "orders"
  add_foreign_key "movements", "product_requests"
  add_foreign_key "movements", "products"
  add_foreign_key "movements", "prospects"
  add_foreign_key "movements", "stores"
  add_foreign_key "movements", "suppliers"
  add_foreign_key "movements", "users"
  add_foreign_key "orders", "billing_addresses"
  add_foreign_key "orders", "carriers"
  add_foreign_key "orders", "delivery_addresses"
  add_foreign_key "orders", "prospects"
  add_foreign_key "orders", "requests"
  add_foreign_key "orders", "stores"
  add_foreign_key "orders_users", "orders"
  add_foreign_key "orders_users", "users"
  add_foreign_key "payments", "bill_receiveds"
  add_foreign_key "payments", "suppliers"
  add_foreign_key "pending_movements", "bills"
  add_foreign_key "pending_movements", "business_units"
  add_foreign_key "pending_movements", "orders"
  add_foreign_key "pending_movements", "product_requests"
  add_foreign_key "pending_movements", "products"
  add_foreign_key "pending_movements", "prospects"
  add_foreign_key "pending_movements", "stores"
  add_foreign_key "pending_movements", "suppliers"
  add_foreign_key "pending_movements", "users"
  add_foreign_key "product_requests", "delivery_packages"
  add_foreign_key "product_requests", "orders"
  add_foreign_key "product_requests", "products"
  add_foreign_key "product_sales", "products"
  add_foreign_key "production_orders", "users"
  add_foreign_key "production_requests", "production_orders"
  add_foreign_key "production_requests", "products"
  add_foreign_key "products", "business_units"
  add_foreign_key "products", "sat_keys"
  add_foreign_key "products", "sat_unit_keys"
  add_foreign_key "products", "units"
  add_foreign_key "products", "warehouses"
  add_foreign_key "products_bills", "bills"
  add_foreign_key "products_bills", "products"
  add_foreign_key "prospect_sales", "prospects"
  add_foreign_key "prospects", "billing_addresses"
  add_foreign_key "prospects", "business_groups"
  add_foreign_key "prospects", "business_units"
  add_foreign_key "prospects", "delivery_addresses"
  add_foreign_key "prospects", "stores"
  add_foreign_key "request_users", "requests"
  add_foreign_key "request_users", "users"
  add_foreign_key "requests", "products"
  add_foreign_key "requests", "prospects"
  add_foreign_key "requests", "stores"
  add_foreign_key "store_sales", "stores"
  add_foreign_key "store_types", "business_units"
  add_foreign_key "stores", "billing_addresses"
  add_foreign_key "stores", "business_groups"
  add_foreign_key "stores", "business_units"
  add_foreign_key "stores", "cost_types"
  add_foreign_key "stores", "delivery_addresses"
  add_foreign_key "stores", "store_types"
  add_foreign_key "suppliers", "delivery_addresses"
  add_foreign_key "suppliers", "stores"
  add_foreign_key "user_requests", "requests"
  add_foreign_key "user_requests", "users"
  add_foreign_key "user_sales", "users"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "stores"
  add_foreign_key "warehouse_entries", "movements"
  add_foreign_key "warehouse_entries", "products"
  add_foreign_key "warehouses", "business_groups"
  add_foreign_key "warehouses", "business_units"
  add_foreign_key "warehouses", "delivery_addresses"
  add_foreign_key "warehouses", "stores"
end
