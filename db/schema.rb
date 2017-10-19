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

ActiveRecord::Schema.define(version: 20171019201219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_balances", force: :cascade do |t|
    t.float    "balance"
    t.integer  "store_id"
    t.integer  "business_unit_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "bank_balances", ["business_unit_id"], name: "index_bank_balances_on_business_unit_id", using: :btree
  add_index "bank_balances", ["store_id"], name: "index_bank_balances_on_store_id", using: :btree

  create_table "banks", force: :cascade do |t|
    t.string   "name"
    t.string   "rfc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "bill_sales", force: :cascade do |t|
    t.integer  "business_unit_id"
    t.integer  "store_id"
    t.integer  "sales_quantity"
    t.float    "amount"
    t.integer  "month"
    t.integer  "year"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.float    "discount"
  end

  add_index "bill_sales", ["business_unit_id"], name: "index_bill_sales_on_business_unit_id", using: :btree
  add_index "bill_sales", ["store_id"], name: "index_bill_sales_on_store_id", using: :btree

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
    t.integer  "tax_regime_id"
  end

  add_index "billing_addresses", ["tax_regime_id"], name: "index_billing_addresses_on_tax_regime_id", using: :btree

  create_table "bills", force: :cascade do |t|
    t.string   "status"
    t.float    "initial_price"
    t.float    "discount_applied"
    t.float    "price_before_taxes"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "type_of_bill"
    t.integer  "prospect_id"
    t.string   "classification"
    t.float    "amount"
    t.integer  "quantity"
    t.string   "pdf"
    t.string   "xml"
    t.integer  "issuing_company_id"
    t.integer  "receiving_company_id"
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
    t.string   "certificate"
    t.integer  "currency_id"
    t.string   "id_trib_reg_num"
    t.string   "confirmation_key"
    t.float    "exchange_rate"
    t.integer  "country_id"
    t.float    "automatic_discount_applied"
    t.float    "manual_discount_applied"
    t.float    "taxes_transferred"
    t.float    "taxes_witheld"
  end

  add_index "bills", ["cfdi_use_id"], name: "index_bills_on_cfdi_use_id", using: :btree
  add_index "bills", ["child_bills_id"], name: "index_bills_on_child_bills_id", using: :btree
  add_index "bills", ["country_id"], name: "index_bills_on_country_id", using: :btree
  add_index "bills", ["currency_id"], name: "index_bills_on_currency_id", using: :btree
  add_index "bills", ["expedition_zip_id"], name: "index_bills_on_expedition_zip_id", using: :btree
  add_index "bills", ["issuing_company_id"], name: "index_bills_on_issuing_company_id", using: :btree
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
    t.float    "cost"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "sales_quantity"
    t.float    "discount"
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
    t.float    "discount"
  end

  add_index "business_unit_sales", ["business_unit_id"], name: "index_business_unit_sales_on_business_unit_id", using: :btree

  create_table "business_units", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "business_group_id"
    t.integer  "billing_address_id"
    t.boolean  "current"
    t.float    "pending_balance"
    t.boolean  "main",               default: false
  end

  add_index "business_units", ["billing_address_id"], name: "index_business_units_on_billing_address_id", using: :btree
  add_index "business_units", ["business_group_id"], name: "index_business_units_on_business_group_id", using: :btree

  create_table "business_units_suppliers", force: :cascade do |t|
    t.integer  "business_unit_id"
    t.integer  "supplier_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "business_units_suppliers", ["business_unit_id"], name: "index_business_units_suppliers_on_business_unit_id", using: :btree
  add_index "business_units_suppliers", ["supplier_id"], name: "index_business_units_suppliers_on_supplier_id", using: :btree

  create_table "carriers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "delivery_address_id"
  end

  add_index "carriers", ["delivery_address_id"], name: "index_carriers_on_delivery_address_id", using: :btree

  create_table "cash_registers", force: :cascade do |t|
    t.string   "name"
    t.integer  "store_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "balance"
    t.integer  "cash_number"
  end

  add_index "cash_registers", ["store_id"], name: "index_cash_registers_on_store_id", using: :btree

  create_table "cfdi_uses", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "key"
  end

  create_table "change_tickets", force: :cascade do |t|
    t.integer  "ticket_id"
    t.integer  "ticket_number"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "store_id"
    t.integer  "bill_id"
  end

  add_index "change_tickets", ["bill_id"], name: "index_change_tickets_on_bill_id", using: :btree
  add_index "change_tickets", ["store_id"], name: "index_change_tickets_on_store_id", using: :btree
  add_index "change_tickets", ["ticket_id"], name: "index_change_tickets_on_ticket_id", using: :btree

  create_table "classifications", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cost_types", force: :cascade do |t|
    t.string   "warehouse_cost_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "description"
  end

  create_table "countries", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
    t.integer  "decimals"
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
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "movement_id"
    t.integer  "driver_id"
    t.integer  "receiver_id"
  end

  add_index "delivery_attempts", ["driver_id"], name: "index_delivery_attempts_on_driver_id", using: :btree
  add_index "delivery_attempts", ["movement_id"], name: "index_delivery_attempts_on_movement_id", using: :btree
  add_index "delivery_attempts", ["product_request_id"], name: "index_delivery_attempts_on_product_request_id", using: :btree
  add_index "delivery_attempts", ["receiver_id"], name: "index_delivery_attempts_on_receiver_id", using: :btree

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

  create_table "delivery_services", force: :cascade do |t|
    t.string   "sender_name"
    t.string   "sender_zipcode"
    t.string   "tracking_number"
    t.string   "receivers_name"
    t.string   "contact_name"
    t.string   "street"
    t.string   "exterior_number"
    t.string   "interior_number"
    t.string   "neighborhood"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "phone"
    t.string   "cellphone"
    t.string   "email"
    t.string   "company"
    t.integer  "service_offered_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "receivers_zipcode"
  end

  add_index "delivery_services", ["service_offered_id"], name: "index_delivery_services_on_service_offered_id", using: :btree

  create_table "deposits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "store_id"
    t.float    "amount"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "cash_register_id"
    t.string   "name"
  end

  add_index "deposits", ["cash_register_id"], name: "index_deposits_on_cash_register_id", using: :btree
  add_index "deposits", ["store_id"], name: "index_deposits_on_store_id", using: :btree
  add_index "deposits", ["user_id"], name: "index_deposits_on_user_id", using: :btree

  create_table "design_costs", force: :cascade do |t|
    t.string   "complexity"
    t.float    "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "design_likes", force: :cascade do |t|
    t.string   "name"
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

  create_table "discount_rules", force: :cascade do |t|
    t.float    "percentage"
    t.text     "product_list",     default: [],               array: true
    t.text     "prospect_list",    default: [],               array: true
    t.date     "initial_date"
    t.date     "final_date"
    t.integer  "user_id"
    t.string   "rule"
    t.float    "minimum_amount",   default: 0.0
    t.integer  "minimum_quantity", default: 0
    t.string   "exclusions"
    t.boolean  "active"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "business_unit_id"
    t.integer  "store_id"
    t.string   "prospect_filter"
    t.string   "product_filter"
    t.boolean  "product_all"
    t.boolean  "prospect_all"
    t.string   "product_gift",     default: [],               array: true
    t.text     "line_filter",      default: [],               array: true
    t.text     "material_filter",  default: [],               array: true
  end

  add_index "discount_rules", ["business_unit_id"], name: "index_discount_rules_on_business_unit_id", using: :btree
  add_index "discount_rules", ["store_id"], name: "index_discount_rules_on_store_id", using: :btree
  add_index "discount_rules", ["user_id"], name: "index_discount_rules_on_user_id", using: :btree

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

  create_table "estimate_docs", force: :cascade do |t|
    t.integer  "prospect_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "store_id"
  end

  add_index "estimate_docs", ["prospect_id"], name: "index_estimate_docs_on_prospect_id", using: :btree
  add_index "estimate_docs", ["store_id"], name: "index_estimate_docs_on_store_id", using: :btree
  add_index "estimate_docs", ["user_id"], name: "index_estimate_docs_on_user_id", using: :btree

  create_table "estimates", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.float    "discount"
    t.integer  "estimate_doc_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "estimates", ["estimate_doc_id"], name: "index_estimates_on_estimate_doc_id", using: :btree
  add_index "estimates", ["product_id"], name: "index_estimates_on_product_id", using: :btree

  create_table "exhibition_inventories", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "exhibition_inventories", ["product_id"], name: "index_exhibition_inventories_on_product_id", using: :btree
  add_index "exhibition_inventories", ["store_id"], name: "index_exhibition_inventories_on_store_id", using: :btree

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
    t.string   "expense_type"
    t.float    "taxes"
    t.integer  "payment_id"
  end

  add_index "expenses", ["bill_received_id"], name: "index_expenses_on_bill_received_id", using: :btree
  add_index "expenses", ["business_unit_id"], name: "index_expenses_on_business_unit_id", using: :btree
  add_index "expenses", ["payment_id"], name: "index_expenses_on_payment_id", using: :btree
  add_index "expenses", ["store_id"], name: "index_expenses_on_store_id", using: :btree
  add_index "expenses", ["user_id"], name: "index_expenses_on_user_id", using: :btree

  create_table "exterior_colors", force: :cascade do |t|
    t.string   "name"
    t.integer  "material_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "exterior_colors", ["material_id"], name: "index_exterior_colors_on_material_id", using: :btree

  create_table "finishings", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "product_id"
  end

  add_index "images", ["product_id"], name: "index_images_on_product_id", using: :btree

  create_table "interior_colors", force: :cascade do |t|
    t.string   "name"
    t.integer  "material_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "interior_colors", ["material_id"], name: "index_interior_colors_on_material_id", using: :btree

  create_table "inventories", force: :cascade do |t|
    t.integer  "product_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "quantity",    default: 0
    t.string   "unique_code"
    t.boolean  "alert"
    t.string   "alert_type"
  end

  add_index "inventories", ["product_id"], name: "index_inventories_on_product_id", using: :btree

  create_table "materials", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials_resistances", force: :cascade do |t|
    t.integer  "material_id"
    t.integer  "resistance_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "materials_resistances", ["material_id"], name: "index_materials_resistances_on_material_id", using: :btree
  add_index "materials_resistances", ["resistance_id"], name: "index_materials_resistances_on_resistance_id", using: :btree

  create_table "movements", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.string   "movement_type"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
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
    t.boolean  "confirm",            default: false
    t.float    "discount_applied",   default: 0.0
    t.float    "final_price"
    t.float    "automatic_discount", default: 0.0
    t.float    "manual_discount",    default: 0.0
    t.integer  "discount_rule_id"
    t.float    "amount"
    t.integer  "seller_user_id"
    t.integer  "buyer_user_id"
    t.boolean  "rule_could_be",      default: false
    t.integer  "ticket_id"
    t.integer  "tax_id"
    t.float    "taxes"
    t.float    "total_cost"
  end

  add_index "movements", ["bill_id"], name: "index_movements_on_bill_id", using: :btree
  add_index "movements", ["business_unit_id"], name: "index_movements_on_business_unit_id", using: :btree
  add_index "movements", ["buyer_user_id"], name: "index_movements_on_buyer_user_id", using: :btree
  add_index "movements", ["discount_rule_id"], name: "index_movements_on_discount_rule_id", using: :btree
  add_index "movements", ["order_id"], name: "index_movements_on_order_id", using: :btree
  add_index "movements", ["product_id"], name: "index_movements_on_product_id", using: :btree
  add_index "movements", ["product_request_id"], name: "index_movements_on_product_request_id", using: :btree
  add_index "movements", ["prospect_id"], name: "index_movements_on_prospect_id", using: :btree
  add_index "movements", ["seller_user_id"], name: "index_movements_on_seller_user_id", using: :btree
  add_index "movements", ["store_id"], name: "index_movements_on_store_id", using: :btree
  add_index "movements", ["supplier_id"], name: "index_movements_on_supplier_id", using: :btree
  add_index "movements", ["tax_id"], name: "index_movements_on_tax_id", using: :btree
  add_index "movements", ["ticket_id"], name: "index_movements_on_ticket_id", using: :btree
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
    t.integer  "bill_id"
    t.integer  "delivery_attempt_id"
  end

  add_index "orders", ["bill_id"], name: "index_orders_on_bill_id", using: :btree
  add_index "orders", ["billing_address_id"], name: "index_orders_on_billing_address_id", using: :btree
  add_index "orders", ["carrier_id"], name: "index_orders_on_carrier_id", using: :btree
  add_index "orders", ["delivery_address_id"], name: "index_orders_on_delivery_address_id", using: :btree
  add_index "orders", ["delivery_attempt_id"], name: "index_orders_on_delivery_attempt_id", using: :btree
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
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "active",      default: true
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
    t.string   "payment_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "method"
  end

  create_table "payments", force: :cascade do |t|
    t.date     "payment_date"
    t.float    "amount"
    t.integer  "bill_received_id"
    t.integer  "supplier_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.integer  "store_id"
    t.integer  "business_unit_id"
    t.integer  "payment_form_id"
    t.string   "payment_type"
    t.integer  "bill_id"
    t.integer  "terminal_id"
    t.integer  "ticket_id"
    t.string   "operation_number"
    t.integer  "payment_number"
    t.integer  "bank_id"
    t.integer  "credit_days"
  end

  add_index "payments", ["bank_id"], name: "index_payments_on_bank_id", using: :btree
  add_index "payments", ["bill_id"], name: "index_payments_on_bill_id", using: :btree
  add_index "payments", ["bill_received_id"], name: "index_payments_on_bill_received_id", using: :btree
  add_index "payments", ["business_unit_id"], name: "index_payments_on_business_unit_id", using: :btree
  add_index "payments", ["payment_form_id"], name: "index_payments_on_payment_form_id", using: :btree
  add_index "payments", ["store_id"], name: "index_payments_on_store_id", using: :btree
  add_index "payments", ["supplier_id"], name: "index_payments_on_supplier_id", using: :btree
  add_index "payments", ["terminal_id"], name: "index_payments_on_terminal_id", using: :btree
  add_index "payments", ["ticket_id"], name: "index_payments_on_ticket_id", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "pending_movements", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
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
    t.float    "discount_applied",   default: 0.0
    t.float    "final_price"
    t.float    "automatic_discount", default: 0.0
    t.float    "manual_discount",    default: 0.0
    t.integer  "discount_rule_id"
    t.integer  "seller_user_id"
    t.integer  "buyer_user_id"
    t.integer  "ticket_id"
    t.float    "total_cost"
  end

  add_index "pending_movements", ["bill_id"], name: "index_pending_movements_on_bill_id", using: :btree
  add_index "pending_movements", ["business_unit_id"], name: "index_pending_movements_on_business_unit_id", using: :btree
  add_index "pending_movements", ["buyer_user_id"], name: "index_pending_movements_on_buyer_user_id", using: :btree
  add_index "pending_movements", ["discount_rule_id"], name: "index_pending_movements_on_discount_rule_id", using: :btree
  add_index "pending_movements", ["order_id"], name: "index_pending_movements_on_order_id", using: :btree
  add_index "pending_movements", ["product_id"], name: "index_pending_movements_on_product_id", using: :btree
  add_index "pending_movements", ["product_request_id"], name: "index_pending_movements_on_product_request_id", using: :btree
  add_index "pending_movements", ["prospect_id"], name: "index_pending_movements_on_prospect_id", using: :btree
  add_index "pending_movements", ["seller_user_id"], name: "index_pending_movements_on_seller_user_id", using: :btree
  add_index "pending_movements", ["store_id"], name: "index_pending_movements_on_store_id", using: :btree
  add_index "pending_movements", ["supplier_id"], name: "index_pending_movements_on_supplier_id", using: :btree
  add_index "pending_movements", ["ticket_id"], name: "index_pending_movements_on_ticket_id", using: :btree
  add_index "pending_movements", ["user_id"], name: "index_pending_movements_on_user_id", using: :btree

  create_table "product_requests", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.string   "status"
    t.integer  "order_id"
    t.string   "urgency_level"
    t.date     "maximum_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "armed"
    t.integer  "surplus"
    t.integer  "excess"
  end

  add_index "product_requests", ["order_id"], name: "index_product_requests_on_order_id", using: :btree
  add_index "product_requests", ["product_id"], name: "index_product_requests_on_product_id", using: :btree

  create_table "product_sales", force: :cascade do |t|
    t.float    "sales_amount"
    t.integer  "sales_quantity"
    t.float    "cost"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "product_id"
    t.integer  "month"
    t.integer  "year"
    t.integer  "store_id"
    t.integer  "business_unit_id"
    t.float    "discount"
  end

  add_index "product_sales", ["business_unit_id"], name: "index_product_sales_on_business_unit_id", using: :btree
  add_index "product_sales", ["product_id"], name: "index_product_sales_on_product_id", using: :btree
  add_index "product_sales", ["store_id"], name: "index_product_sales_on_store_id", using: :btree

  create_table "product_types", force: :cascade do |t|
    t.string   "product_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

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
    t.integer  "sat_key_id"
    t.integer  "sat_unit_key_id"
    t.boolean  "current"
    t.integer  "store_id"
    t.integer  "supplier_id"
  end

  add_index "products", ["business_unit_id"], name: "index_products_on_business_unit_id", using: :btree
  add_index "products", ["sat_key_id"], name: "index_products_on_sat_key_id", using: :btree
  add_index "products", ["sat_unit_key_id"], name: "index_products_on_sat_unit_key_id", using: :btree
  add_index "products", ["store_id"], name: "index_products_on_store_id", using: :btree
  add_index "products", ["supplier_id"], name: "index_products_on_supplier_id", using: :btree
  add_index "products", ["warehouse_id"], name: "index_products_on_warehouse_id", using: :btree

  create_table "prospect_sales", force: :cascade do |t|
    t.integer  "prospect_id"
    t.float    "sales_amount"
    t.integer  "sales_quantity"
    t.float    "cost"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "month"
    t.integer  "year"
    t.integer  "store_id"
    t.integer  "business_unit_id"
    t.float    "discount"
  end

  add_index "prospect_sales", ["business_unit_id"], name: "index_prospect_sales_on_business_unit_id", using: :btree
  add_index "prospect_sales", ["prospect_id"], name: "index_prospect_sales_on_prospect_id", using: :btree
  add_index "prospect_sales", ["store_id"], name: "index_prospect_sales_on_store_id", using: :btree

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
    t.integer  "store_type_id"
    t.integer  "store_prospect_id"
    t.integer  "credit_days"
  end

  add_index "prospects", ["billing_address_id"], name: "index_prospects_on_billing_address_id", using: :btree
  add_index "prospects", ["business_group_id"], name: "index_prospects_on_business_group_id", using: :btree
  add_index "prospects", ["business_unit_id"], name: "index_prospects_on_business_unit_id", using: :btree
  add_index "prospects", ["delivery_address_id"], name: "index_prospects_on_delivery_address_id", using: :btree
  add_index "prospects", ["store_id"], name: "index_prospects_on_store_id", using: :btree
  add_index "prospects", ["store_prospect_id"], name: "index_prospects_on_store_prospect_id", using: :btree
  add_index "prospects", ["store_type_id"], name: "index_prospects_on_store_type_id", using: :btree

  create_table "relation_types", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "key"
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
    t.integer  "estimate_doc_id"
  end

  add_index "requests", ["estimate_doc_id"], name: "index_requests_on_estimate_doc_id", using: :btree
  add_index "requests", ["product_id"], name: "index_requests_on_product_id", using: :btree
  add_index "requests", ["prospect_id"], name: "index_requests_on_prospect_id", using: :btree
  add_index "requests", ["store_id"], name: "index_requests_on_store_id", using: :btree

  create_table "resistances", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "return_tickets", force: :cascade do |t|
    t.integer  "ticket_id"
    t.integer  "ticket_number"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "store_id"
    t.integer  "bill_id"
  end

  add_index "return_tickets", ["bill_id"], name: "index_return_tickets_on_bill_id", using: :btree
  add_index "return_tickets", ["store_id"], name: "index_return_tickets_on_store_id", using: :btree
  add_index "return_tickets", ["ticket_id"], name: "index_return_tickets_on_ticket_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "translation"
  end

  create_table "sales_targets", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "month"
    t.integer  "year"
    t.float    "target"
    t.float    "actual_sales"
    t.boolean  "achieved"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "sales_targets", ["store_id"], name: "index_sales_targets_on_store_id", using: :btree

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

  create_table "sat_zipcodes", force: :cascade do |t|
    t.string   "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_offereds", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "store_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.float    "initial_price"
    t.float    "automatic_discount", default: 0.0
    t.float    "manual_discount",    default: 0.0
    t.float    "discount_applied",   default: 0.0
    t.boolean  "rule_could_be"
    t.float    "final_price"
    t.float    "amount"
    t.string   "service_type"
    t.integer  "return_ticket_id"
    t.integer  "change_ticket_id"
    t.integer  "tax_id"
    t.float    "taxes"
    t.float    "cost"
    t.integer  "ticket_id"
    t.float    "total_cost"
    t.integer  "quantity"
    t.string   "discount_reason"
  end

  add_index "service_offereds", ["change_ticket_id"], name: "index_service_offereds_on_change_ticket_id", using: :btree
  add_index "service_offereds", ["return_ticket_id"], name: "index_service_offereds_on_return_ticket_id", using: :btree
  add_index "service_offereds", ["service_id"], name: "index_service_offereds_on_service_id", using: :btree
  add_index "service_offereds", ["store_id"], name: "index_service_offereds_on_store_id", using: :btree
  add_index "service_offereds", ["tax_id"], name: "index_service_offereds_on_tax_id", using: :btree
  add_index "service_offereds", ["ticket_id"], name: "index_service_offereds_on_ticket_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "unique_code"
    t.text     "description"
    t.float    "price"
    t.integer  "sat_key_id"
    t.string   "unit"
    t.integer  "sat_unit_key_id"
    t.boolean  "shared"
    t.integer  "store_id"
    t.integer  "business_unit_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "delivery_company"
  end

  add_index "services", ["business_unit_id"], name: "index_services_on_business_unit_id", using: :btree
  add_index "services", ["sat_key_id"], name: "index_services_on_sat_key_id", using: :btree
  add_index "services", ["sat_unit_key_id"], name: "index_services_on_sat_unit_key_id", using: :btree
  add_index "services", ["store_id"], name: "index_services_on_store_id", using: :btree

  create_table "store_movements", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.string   "movement_type"
    t.integer  "order_id"
    t.integer  "ticket_id"
    t.integer  "store_id"
    t.float    "initial_price"
    t.float    "automatic_discount", default: 0.0
    t.float    "manual_discount",    default: 0.0
    t.float    "discount_applied",   default: 0.0
    t.boolean  "rule_could_be"
    t.float    "final_price"
    t.float    "amount"
    t.integer  "return_ticket_id"
    t.integer  "change_ticket_id"
    t.integer  "tax_id"
    t.float    "taxes"
    t.float    "cost"
    t.integer  "supplier_id"
    t.integer  "product_request_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.float    "total_cost"
    t.string   "discount_reason"
  end

  add_index "store_movements", ["change_ticket_id"], name: "index_store_movements_on_change_ticket_id", using: :btree
  add_index "store_movements", ["order_id"], name: "index_store_movements_on_order_id", using: :btree
  add_index "store_movements", ["product_id"], name: "index_store_movements_on_product_id", using: :btree
  add_index "store_movements", ["product_request_id"], name: "index_store_movements_on_product_request_id", using: :btree
  add_index "store_movements", ["return_ticket_id"], name: "index_store_movements_on_return_ticket_id", using: :btree
  add_index "store_movements", ["store_id"], name: "index_store_movements_on_store_id", using: :btree
  add_index "store_movements", ["supplier_id"], name: "index_store_movements_on_supplier_id", using: :btree
  add_index "store_movements", ["tax_id"], name: "index_store_movements_on_tax_id", using: :btree
  add_index "store_movements", ["ticket_id"], name: "index_store_movements_on_ticket_id", using: :btree

  create_table "store_sales", force: :cascade do |t|
    t.integer  "store_id"
    t.string   "month"
    t.string   "year"
    t.float    "sales_amount"
    t.integer  "sales_quantity"
    t.float    "cost"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.float    "discount"
  end

  add_index "store_sales", ["store_id"], name: "index_store_sales_on_store_id", using: :btree

  create_table "store_types", force: :cascade do |t|
    t.string   "store_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "store_use_inventories", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "store_use_inventories", ["product_id"], name: "index_store_use_inventories_on_product_id", using: :btree
  add_index "store_use_inventories", ["store_id"], name: "index_store_use_inventories_on_store_id", using: :btree

  create_table "stores", force: :cascade do |t|
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "store_code"
    t.string   "store_name"
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
    t.string   "zip_code"
    t.boolean  "period_sales_achievement"
    t.boolean  "inspection_approved"
    t.float    "overprice",                default: 0.0
    t.string   "series"
    t.integer  "last_bill",                default: 0
  end

  add_index "stores", ["business_group_id"], name: "index_stores_on_business_group_id", using: :btree
  add_index "stores", ["business_unit_id"], name: "index_stores_on_business_unit_id", using: :btree
  add_index "stores", ["cost_type_id"], name: "index_stores_on_cost_type_id", using: :btree
  add_index "stores", ["delivery_address_id"], name: "index_stores_on_delivery_address_id", using: :btree
  add_index "stores", ["store_type_id"], name: "index_stores_on_store_type_id", using: :btree

  create_table "stores_inventories", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "store_id"
    t.integer  "quantity",            default: 0
    t.boolean  "alert",               default: false
    t.string   "alert_type"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "rack"
    t.string   "level"
    t.boolean  "manual_price_update", default: false
  end

  add_index "stores_inventories", ["product_id"], name: "index_stores_inventories_on_product_id", using: :btree
  add_index "stores_inventories", ["store_id"], name: "index_stores_inventories_on_store_id", using: :btree

  create_table "stores_suppliers", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "supplier_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "stores_suppliers", ["store_id"], name: "index_stores_suppliers_on_store_id", using: :btree
  add_index "stores_suppliers", ["supplier_id"], name: "index_stores_suppliers_on_supplier_id", using: :btree

  create_table "stores_warehouse_entries", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "store_id"
    t.integer  "quantity"
    t.integer  "movement_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "retail_units_per_unit"
    t.integer  "units_used"
    t.integer  "store_movement_id"
  end

  add_index "stores_warehouse_entries", ["movement_id"], name: "index_stores_warehouse_entries_on_movement_id", using: :btree
  add_index "stores_warehouse_entries", ["product_id"], name: "index_stores_warehouse_entries_on_product_id", using: :btree
  add_index "stores_warehouse_entries", ["store_id"], name: "index_stores_warehouse_entries_on_store_id", using: :btree
  add_index "stores_warehouse_entries", ["store_movement_id"], name: "index_stores_warehouse_entries_on_store_movement_id", using: :btree

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
    t.integer  "store_id"
    t.string   "last_purchase_folio"
  end

  add_index "suppliers", ["delivery_address_id"], name: "index_suppliers_on_delivery_address_id", using: :btree
  add_index "suppliers", ["store_id"], name: "index_suppliers_on_store_id", using: :btree

  create_table "tax_regimes", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "tax_id"
    t.boolean  "corporate"
    t.boolean  "particular"
    t.date     "date_since"
  end

  create_table "taxes", force: :cascade do |t|
    t.string   "description"
    t.float    "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "key"
    t.boolean  "transfer"
    t.boolean  "retention"
  end

  create_table "temporal_numbers", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "business_group_id"
    t.string   "past_sales",        default: [],              array: true
    t.string   "future_sales",      default: [],              array: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "temporal_numbers", ["business_group_id"], name: "index_temporal_numbers_on_business_group_id", using: :btree
  add_index "temporal_numbers", ["store_id"], name: "index_temporal_numbers_on_store_id", using: :btree

  create_table "terminals", force: :cascade do |t|
    t.string   "name"
    t.integer  "bank_id"
    t.string   "number"
    t.integer  "store_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.float    "debit_comission"
    t.float    "credit_comission"
  end

  add_index "terminals", ["bank_id"], name: "index_terminals_on_bank_id", using: :btree
  add_index "terminals", ["store_id"], name: "index_terminals_on_store_id", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "store_id"
    t.float    "subtotal"
    t.integer  "tax_id"
    t.float    "taxes"
    t.float    "total"
    t.integer  "prospect_id"
    t.integer  "bill_id"
    t.string   "ticket_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "cash_register_id"
    t.integer  "ticket_number"
    t.integer  "cfdi_use_id"
    t.string   "comments"
  end

  add_index "tickets", ["bill_id"], name: "index_tickets_on_bill_id", using: :btree
  add_index "tickets", ["cash_register_id"], name: "index_tickets_on_cash_register_id", using: :btree
  add_index "tickets", ["cfdi_use_id"], name: "index_tickets_on_cfdi_use_id", using: :btree
  add_index "tickets", ["prospect_id"], name: "index_tickets_on_prospect_id", using: :btree
  add_index "tickets", ["store_id"], name: "index_tickets_on_store_id", using: :btree
  add_index "tickets", ["tax_id"], name: "index_tickets_on_tax_id", using: :btree
  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id", using: :btree

  create_table "type_of_bills", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "key"
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.string   "plural_name"
    t.string   "abbreviation"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
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
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "movement_id"
    t.integer  "store_id"
    t.integer  "retail_units_per_unit"
    t.integer  "units_used"
  end

  add_index "warehouse_entries", ["movement_id"], name: "index_warehouse_entries_on_movement_id", using: :btree
  add_index "warehouse_entries", ["product_id"], name: "index_warehouse_entries_on_product_id", using: :btree
  add_index "warehouse_entries", ["store_id"], name: "index_warehouse_entries_on_store_id", using: :btree

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

  create_table "withdrawals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "store_id"
    t.float    "amount"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "cash_register_id"
    t.string   "name"
  end

  add_index "withdrawals", ["cash_register_id"], name: "index_withdrawals_on_cash_register_id", using: :btree
  add_index "withdrawals", ["store_id"], name: "index_withdrawals_on_store_id", using: :btree
  add_index "withdrawals", ["user_id"], name: "index_withdrawals_on_user_id", using: :btree

  add_foreign_key "bank_balances", "business_units"
  add_foreign_key "bank_balances", "stores"
  add_foreign_key "bill_receiveds", "business_units"
  add_foreign_key "bill_receiveds", "products"
  add_foreign_key "bill_receiveds", "stores"
  add_foreign_key "bill_receiveds", "suppliers"
  add_foreign_key "bill_sales", "business_units"
  add_foreign_key "bill_sales", "stores"
  add_foreign_key "billing_addresses", "tax_regimes"
  add_foreign_key "bills", "cfdi_uses"
  add_foreign_key "bills", "countries"
  add_foreign_key "bills", "currencies"
  add_foreign_key "bills", "expedition_zips"
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
  add_foreign_key "business_units_suppliers", "business_units"
  add_foreign_key "business_units_suppliers", "suppliers"
  add_foreign_key "carriers", "delivery_addresses"
  add_foreign_key "cash_registers", "stores"
  add_foreign_key "change_tickets", "bills"
  add_foreign_key "change_tickets", "stores"
  add_foreign_key "change_tickets", "tickets"
  add_foreign_key "delivery_attempts", "movements"
  add_foreign_key "delivery_attempts", "product_requests"
  add_foreign_key "delivery_packages", "delivery_attempts"
  add_foreign_key "delivery_packages", "orders"
  add_foreign_key "delivery_services", "service_offereds"
  add_foreign_key "deposits", "cash_registers"
  add_foreign_key "deposits", "stores"
  add_foreign_key "deposits", "users"
  add_foreign_key "design_request_users", "design_requests"
  add_foreign_key "design_request_users", "users"
  add_foreign_key "design_requests", "requests"
  add_foreign_key "discount_rules", "business_units"
  add_foreign_key "discount_rules", "stores"
  add_foreign_key "discount_rules", "users"
  add_foreign_key "documents", "design_requests"
  add_foreign_key "documents", "requests"
  add_foreign_key "estimate_docs", "prospects"
  add_foreign_key "estimate_docs", "stores"
  add_foreign_key "estimate_docs", "users"
  add_foreign_key "estimates", "estimate_docs"
  add_foreign_key "estimates", "products"
  add_foreign_key "exhibition_inventories", "products"
  add_foreign_key "exhibition_inventories", "stores"
  add_foreign_key "expenses", "bill_receiveds"
  add_foreign_key "expenses", "business_units"
  add_foreign_key "expenses", "payments"
  add_foreign_key "expenses", "stores"
  add_foreign_key "expenses", "users"
  add_foreign_key "exterior_colors", "materials"
  add_foreign_key "images", "products"
  add_foreign_key "interior_colors", "materials"
  add_foreign_key "inventories", "products"
  add_foreign_key "materials_resistances", "materials"
  add_foreign_key "materials_resistances", "resistances"
  add_foreign_key "movements", "bills"
  add_foreign_key "movements", "business_units"
  add_foreign_key "movements", "discount_rules"
  add_foreign_key "movements", "orders"
  add_foreign_key "movements", "product_requests"
  add_foreign_key "movements", "products"
  add_foreign_key "movements", "prospects"
  add_foreign_key "movements", "stores"
  add_foreign_key "movements", "suppliers"
  add_foreign_key "movements", "taxes"
  add_foreign_key "movements", "tickets"
  add_foreign_key "movements", "users"
  add_foreign_key "orders", "billing_addresses"
  add_foreign_key "orders", "bills"
  add_foreign_key "orders", "carriers"
  add_foreign_key "orders", "delivery_addresses"
  add_foreign_key "orders", "delivery_attempts"
  add_foreign_key "orders", "prospects"
  add_foreign_key "orders", "requests"
  add_foreign_key "orders", "stores"
  add_foreign_key "orders_users", "orders"
  add_foreign_key "orders_users", "users"
  add_foreign_key "payments", "banks"
  add_foreign_key "payments", "bill_receiveds"
  add_foreign_key "payments", "bills"
  add_foreign_key "payments", "business_units"
  add_foreign_key "payments", "payment_forms"
  add_foreign_key "payments", "stores"
  add_foreign_key "payments", "suppliers"
  add_foreign_key "payments", "terminals"
  add_foreign_key "payments", "tickets"
  add_foreign_key "payments", "users"
  add_foreign_key "pending_movements", "bills"
  add_foreign_key "pending_movements", "business_units"
  add_foreign_key "pending_movements", "discount_rules"
  add_foreign_key "pending_movements", "orders"
  add_foreign_key "pending_movements", "product_requests"
  add_foreign_key "pending_movements", "products"
  add_foreign_key "pending_movements", "prospects"
  add_foreign_key "pending_movements", "stores"
  add_foreign_key "pending_movements", "suppliers"
  add_foreign_key "pending_movements", "tickets"
  add_foreign_key "pending_movements", "users"
  add_foreign_key "product_requests", "orders"
  add_foreign_key "product_requests", "products"
  add_foreign_key "product_sales", "business_units"
  add_foreign_key "product_sales", "products"
  add_foreign_key "product_sales", "stores"
  add_foreign_key "production_orders", "users"
  add_foreign_key "production_requests", "production_orders"
  add_foreign_key "production_requests", "products"
  add_foreign_key "products", "business_units"
  add_foreign_key "products", "sat_keys"
  add_foreign_key "products", "sat_unit_keys"
  add_foreign_key "products", "stores"
  add_foreign_key "products", "suppliers"
  add_foreign_key "products", "warehouses"
  add_foreign_key "prospect_sales", "business_units"
  add_foreign_key "prospect_sales", "prospects"
  add_foreign_key "prospect_sales", "stores"
  add_foreign_key "prospects", "billing_addresses"
  add_foreign_key "prospects", "business_groups"
  add_foreign_key "prospects", "business_units"
  add_foreign_key "prospects", "delivery_addresses"
  add_foreign_key "prospects", "store_types"
  add_foreign_key "prospects", "stores"
  add_foreign_key "request_users", "requests"
  add_foreign_key "request_users", "users"
  add_foreign_key "requests", "estimate_docs"
  add_foreign_key "requests", "products"
  add_foreign_key "requests", "prospects"
  add_foreign_key "requests", "stores"
  add_foreign_key "return_tickets", "bills"
  add_foreign_key "return_tickets", "stores"
  add_foreign_key "return_tickets", "tickets"
  add_foreign_key "sales_targets", "stores"
  add_foreign_key "service_offereds", "change_tickets"
  add_foreign_key "service_offereds", "return_tickets"
  add_foreign_key "service_offereds", "services"
  add_foreign_key "service_offereds", "stores"
  add_foreign_key "service_offereds", "taxes"
  add_foreign_key "service_offereds", "tickets"
  add_foreign_key "services", "business_units"
  add_foreign_key "services", "sat_keys"
  add_foreign_key "services", "sat_unit_keys"
  add_foreign_key "services", "stores"
  add_foreign_key "store_movements", "change_tickets"
  add_foreign_key "store_movements", "orders"
  add_foreign_key "store_movements", "product_requests"
  add_foreign_key "store_movements", "products"
  add_foreign_key "store_movements", "return_tickets"
  add_foreign_key "store_movements", "stores"
  add_foreign_key "store_movements", "suppliers"
  add_foreign_key "store_movements", "taxes"
  add_foreign_key "store_movements", "tickets"
  add_foreign_key "store_sales", "stores"
  add_foreign_key "store_use_inventories", "products"
  add_foreign_key "store_use_inventories", "stores"
  add_foreign_key "stores", "business_groups"
  add_foreign_key "stores", "business_units"
  add_foreign_key "stores", "cost_types"
  add_foreign_key "stores", "delivery_addresses"
  add_foreign_key "stores", "store_types"
  add_foreign_key "stores_inventories", "products"
  add_foreign_key "stores_inventories", "stores"
  add_foreign_key "stores_suppliers", "stores"
  add_foreign_key "stores_suppliers", "suppliers"
  add_foreign_key "stores_warehouse_entries", "movements"
  add_foreign_key "stores_warehouse_entries", "products"
  add_foreign_key "stores_warehouse_entries", "store_movements"
  add_foreign_key "stores_warehouse_entries", "stores"
  add_foreign_key "suppliers", "delivery_addresses"
  add_foreign_key "suppliers", "stores"
  add_foreign_key "temporal_numbers", "business_groups"
  add_foreign_key "temporal_numbers", "stores"
  add_foreign_key "terminals", "banks"
  add_foreign_key "terminals", "stores"
  add_foreign_key "tickets", "bills"
  add_foreign_key "tickets", "cash_registers"
  add_foreign_key "tickets", "cfdi_uses"
  add_foreign_key "tickets", "prospects"
  add_foreign_key "tickets", "stores"
  add_foreign_key "tickets", "taxes"
  add_foreign_key "tickets", "users"
  add_foreign_key "user_requests", "requests"
  add_foreign_key "user_requests", "users"
  add_foreign_key "user_sales", "users"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "stores"
  add_foreign_key "warehouse_entries", "movements"
  add_foreign_key "warehouse_entries", "products"
  add_foreign_key "warehouse_entries", "stores"
  add_foreign_key "warehouses", "business_groups"
  add_foreign_key "warehouses", "business_units"
  add_foreign_key "warehouses", "delivery_addresses"
  add_foreign_key "warehouses", "stores"
  add_foreign_key "withdrawals", "cash_registers"
  add_foreign_key "withdrawals", "stores"
  add_foreign_key "withdrawals", "users"
end
