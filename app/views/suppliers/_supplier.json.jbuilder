json.extract! supplier, :id, :name, :business_type, :legal_or_business_name, :type_of_person, :contact_first_name, :contact_middle_name, :contact_last_name, :contact_position, :direct_phone, :extension, :cell_phone, :email, :supplier_status, :delivery_address_id, :last_purchase_bill_date, :last_purhcase_folio, :business_unit_id, :store_id, :created_at, :updated_at
json.url supplier_url(supplier, format: :json)
