# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

# Agrega el catálogo de Régimen fiscal del SAT
# csv_text = File.read(Rails.root.join('lib', 'seeds', 'tax_regime.csv'))
# csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
# csv.each do |row|
#   t = TaxRegime.new
#   t.tax_id = row['tax_id']
#   t.description = row['description']
#   t.particular = row['particular']
#   t.corporate = row['corporate']
#   t.date_since = row['date_since']
#   t.save
#   puts "#{t.id}, #{t.tax_id}, #{t.description} saved"
# end

# puts "There are now #{TaxRegime.count} rows in the Tax Regime table"

# Agrega el catálogo de Forma de pago del SAT
# csv_text = File.read(Rails.root.join('lib', 'seeds', 'payment_form.csv'))
# csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
# csv.each do |row|
#   t = PaymentForm.new
#   t.payment_id = row['payment_id']
#   t.description = row['description']
#   t.save
#   puts "#{t.id}, #{t.payment_id}, #{t.description} saved"
# end


# Agrega el catálogo de Método de pago del SAT
# csv_text = File.read(Rails.root.join('lib', 'seeds', 'payment_method.csv'))
# csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
# csv.each do |row|
#   t = PaymentMethod.new
#   t.method = row['method']
#   t.description = row['description']
#   t.save
#   puts "#{t.id}, #{t.method}, #{t.description} saved"
# end


# Agrega el catálogo de Clave de productos del SAT
# csv_text = File.read(Rails.root.join('lib', 'seeds', 'sat_key.csv'))
# csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
# csv.each do |row|
#   t = SatKey.new
#   t.sat_key = row['sat_key']
#   t.description = row['description']
#   t.save
#   puts "#{t.id}, #{t.sat_key}, #{t.description} saved"
# end


# Agrega el catálogo de Unidad de productos del SAT
# csv_text = File.read(Rails.root.join('lib', 'seeds', 'sat_unit_key.csv'))
# csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
# csv.each do |row|
#   t = SatUnitKey.new
#   t.unit = row['unit']
#   t.description = row['description']
#   t.save
#   puts "#{t.id}, #{t.unit}, #{t.description} saved"
# end


# Agrega el catálogo del Código Postal de productos del SAT
# csv_text = File.read(Rails.root.join('lib', 'seeds', 'sat_zipcode.csv'))
# csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
# csv.each do |row|
#   t = SatZipcode.new
#   t.zipcode = row['zipcode']
#   t.save
#   puts "#{t.id}, #{t.zipcode} saved"
# end

# puts "There are now #{PaymentForm.count} rows in the Payment Form table"
# puts "There are now #{PaymentMethod.count} rows in the Payment Method table"
# puts "There are now #{SatKey.count} rows in the SAT Key table"
# puts "There are now #{SatUnitKey.count} rows in the SAT Unit Key table"
# puts "There are now #{SatZipcode.count} rows in the SAT ZipCode table"


# # Agrega el catálogo de monedas del SAT
# csv_text = File.read(Rails.root.join('lib', 'seeds', 'currency.csv'))
# csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
# csv.each do |row|
#  t = Currency.new
#  t.name = row['name']
#  t.description = row['description']
#  t.decimals = row['decimals']
#  t.save
#  puts "#{t.id}, #{t.name} saved"
# end

# puts "There are now #{Currency.count} rows in the Currency table"

# # Agrega el catálogo de países del SAT
# csv_text = File.read(Rails.root.join('lib', 'seeds', 'country.csv'))
# csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
# csv.each do |row|
#  t = Country.new
#  t.key = row['key']
#  t.name = row['name']
#  t.save
#  puts "#{t.id}, #{t.name} saved"
# end

# puts "There are now #{Country.count} rows in the Country table"

# Agrega el catálogo de tipo de relaciones del CFDI del SAT
# csv_text = File.read(Rails.root.join('lib', 'seeds', 'relation_type.csv'))
# csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
# csv.each do |row|
#  t = RelationType.new
#  t.key = row['key']
#  t.description = row['description']
#  t.save
#  puts "#{t.id}, #{t.key} saved"
# end

# puts "There are now #{RelationType.count} rows in the Relation Type table"

# Agrega el catálogo de uso de CFDI del SAT
# csv_text = File.read(Rails.root.join('lib', 'seeds', 'cfdi_use.csv'))
# csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
# csv.each do |row|
#  t = CfdiUse.new
#  t.key = row['key']
#  t.description = row['description']
#  t.save
#  puts "#{t.id}, #{t.key} saved"
# end

# puts "There are now #{CfdiUse.count} rows in the CFDI Use table"

#  Agrega el catálogo de Productos de Diseños de Cartón
  csv_text = File.read(Rails.root.join('lib', 'seeds', 'products_trial.csv'))
  csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
  csv.each do |row|
    product = Product.find_or_create_by(
                                  {
                                    unique_code: row['cod'],
                                    description: row['desc'],
                                    business_unit: BusinessUnit.find_by_name(row['bu']),
                                    line: Classification.find_by_name(row['line']).name,
                                    classification: row['class'],
                                    product_type: row['type'],
                                    price: row['price']
                                  }
    )
    puts "#{product.id}, #{product.unique_code} saved"
    i = Inventory.find_or_create_by(
                                {
                                  product: product,
                                  unique_code: product.unique_code
                                }
    )
    puts "#{i.id}, #{i.unique_code} saved"
  end

  puts "There are now #{Product.count} rows in the Products table"
  puts "There are now #{Inventory.count} rows in the Inventory table"

#CUANDO AGREGUE EL DIRECTORIO DE TIENDAS, AGREGAR LÍNEAS PARA PROSPECTO Y ALMACÉN Y VER SI HAY OTRAS IMPLICACIONES
