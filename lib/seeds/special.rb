tables = [
  'users',
  'billing_addresses',
  'prospects',
  'cash_registers',
  'tickets',
  'tickets_children',
  'terminals',
  'payments',
  'store_movements',
  'stores_warehouse_entries',
  'stores_inventories',
  'service_offereds',
  'delivery_services',
  'expenses',
  'products',
  'services',
  'banks'
]

tables.each do |table|
  const = table.singularize.camelize.constantize
  const.find_each do |c|
    c.update(web_id: c.id) if c.web_id.nil?
  end
end
