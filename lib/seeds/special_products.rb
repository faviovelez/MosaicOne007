# Este método es solo para la tienda de Bugambilias

csv_text = File.read(Rails.root.join('lib', 'seeds', 'products_final.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  product = Product.find_or_create_by(
                                        {
                                          sat_key: SatKey.find_by_sat_key(row['sat_key']),
                                          unique_code: row['unique_code'],
                                          former_code: row['former_code'],
                                          pieces_per_package: row['pieces_per_package'],
                                          description: row['description'],
                                          number_of_pieces: row['number_of_pieces'],
                                          accesories_kit: row['accesories'],
                                          supplier: Supplier.find_by_name(row['supplier']),
                                          business_unit: BusinessUnit.find_by_name(row['supplier']),
                                          exterior_color_or_design: row['exterior_color_or_design'],
                                          product_type: row['product_type'],
                                          line: Classification.find_by_name(row['line']).name,
                                          classification: row['classification'],
                                          main_material: row['main_material'],
                                          resistance_main_material: row['resistance_main_material'],
                                          design_type: row['design_type'],
                                          warehouse: Warehouse.find_by_name(row['warehouse']),
                                          sat_unit_key: SatUnitKey.find_by_unit(row['sat_unit_key']),
                                          unit: SatUnitKey.find_by_unit(row['sat_unit_key']).description,
                                          only_measure: row['only_measure'],
                                          price: row['price'],
                                          factor: row['factor'],
                                          average: row['average'],
                                          discount_for_franchises: row['stores_discount'],
                                          discount_for_stores: row['retails_discount'],
                                          armed_discount: row['discount_when_armed'],
                                          current: true
                                        }
                                      )

  if row['impression'] == 'sí'
    product.update(impression: true)
  else
    product.update(impression: false)
  end
  if product.classification == 'de tienda'
    product.update(shared: false, store: Store.find_by_store_name('Bugambilias'))
  else
    product.update(shared: true)
  end

  not_armed = (row['discount_when_armed'] == '' || row['discount_when_armed'] == nil)
  product.update(armed: true, armed_discount: row['discount_when_armed']) unless not_armed

  puts "#{product.id}, #{product.unique_code} saved"
end
