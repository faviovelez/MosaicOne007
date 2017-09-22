# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

[
  {name: "platform-admin", translation: "administrador de plataforma", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "director", translation: "director", description: "Tiene acceso a todos los procesos y funciones de manager, puede crear usuarios manager" },
  {name: "manager", translation: "gerente", description: "Asigna precio a cotizaciones y puede asignar costo a las entradas de materiales" },
  {name: "store", translation: "auxiliar de tienda", description: "Crea prospectos, cotizaciones y pedidos, autoriza, cancela o reactiva cotizaciones y pedidos" },
  {name: "store-admin", translation: "jefe de tienda", description: "Con acceso a todas las secciones, reportes y funcionalidades de tienda y puede crear usuarios store" },
  {name: "product-admin", translation: "jefe de producto", description: "Crea y modifica productos, asigna costos a entradas de mercancías, crea usuarios product-staff" },
  {name: "product-staff", translation: "auxiliar de producto", description: "Crea y modifica productos, asigna costos a entradas de mercancías" },
  {name: "warehouse-admin", translation: "jefe de almacén", description: "Maneja inventario, órdenes de producción, prepara pedidos y crea usuarios wharehouse-staff" },
  {name: "warehouse-staff", translation: "auxiliar de almacén", description: "Maneja inventario, órdenes de producción, prepara pedidos" },
  {name: "admin-desk", translation: "administrativo", description: "Crea usuarios tipo drivers, crea envíos y factura, elabora pedidos y cotizaciones" },
  {name: "designer-admin", translation: "jefe de diseñadores", description: "Da respuesta a las solicitudes de diseño y puede crear usuarios designer" },
  {name: "designer", translation: "diseñador", description: "Da respuesta a las solicitudes de diseño" },
  {name: "driver", translation: "chofer", description: "Entrega mercancía" },
  {name: "viewer", translation: "soporte", description: "Da seguimiento a pedidos y cotizaciones" }

].each do |hash|
  Role.find_or_create_by(hash)
end

# Deben existir por lo menos dos Business Groups: Uno para tiendas propias y otro para tiendas externas
[
  { name: "default compañía", business_group_type: 'main' },
  { name: "default terceros" }
].each do |hash|
  BusinessGroup.find_or_create_by(hash)
end

# Se establece por default la configuración de tipo de costeo a PEPS en la tabla CostType
[
  { warehouse_cost_type: "PEPS", description: "Primeras entradas, primeras salidas"},
  { warehouse_cost_type: "UEPS", description: "Últimas entradas, primeras salidas"}
].each do |hash|
  CostType.find_or_create_by(hash)
end

default_cost_type = CostType.find_by_warehouse_cost_type('PEPS')

# Cada tienda debe pertenecer a un Business Unit y cada Business Unit debe pertenecer a un Business Group, se crean defaults para funcionalidad inicial que deben ser modificadas (y/o agregadas nuevas)
default_business_group = BusinessGroup.find_by_name('default compañía')
default_terceros_business_group = BusinessGroup.find_by_name('default terceros')

[
  { name: "default compañía", business_group: default_business_group},
  { name: "default terceros", business_group: default_terceros_business_group}
].each do |hash|
  BusinessUnit.find_or_create_by(hash)
end

default_business_unit = BusinessUnit.find_by_name('default compañía')
default_terceros_business_unit = BusinessUnit.find_by_name('default terceros')

# Se crea el modelo Store_type para los distintos tipos de tiendas. Al crear una tienda, se puede elegir entre los business_units default o los creados o modificados por los usuarios.
[
  { store_type: "tienda propia", business_unit_id: default_business_unit },
  { store_type: "corporativo", business_unit_id: default_business_unit },
  { store_type: "distribuidor", business_unit_id: default_terceros_business_unit },
  { store_type: "franquicia", business_unit_id: default_terceros_business_unit }
].each do |hash|
  StoreType.find_or_create_by(hash)
end

store_type_default = StoreType.find_by_store_type('corporativo')

default_store = Store.find_or_create_by(store_name: 'corporativo', store_code: '000', store_type: store_type_default, business_unit: default_business_unit)

# Se crea un almacén default
Warehouse.create(warehouse_code: 'AG000', name: 'almacén default', business_unit: default_business_unit, business_group: default_business_group)

admin = Role.find_by_name('platform-admin')

User.create(
             email: "admin@adminmosaictech.com",
             first_name: "Administrador",
             last_name: "Diseños de Cartón",
             password: ENV["admin_user_password"],
             password_confirmation: ENV["admin_user_password"],
             role: admin,
             store: default_store
             )

[
  { product_type: 'caja' },
  { product_type: 'bolsa' },
  { product_type: 'exhibidor' }

].each do |hash|
  ProductType.find_or_create_by(hash)
end

[
  { name: 'caple' },
  { name: 'sulfatada' },
  { name: 'multicapa' },
  { name: 'reverso blanco' },
  { name: 'reverso gris' },
  { name: 'liner' },
  { name: 'single face' },
  { name: 'microcorrugado' },
  { name: 'corrugado' },
  { name: 'doble corrugado' },
  { name: 'rígido' },
  { name: 'papel kraft' },
  { name: 'papel bond' },
  { name: 'papel arroz' },
  { name: 'celofán' },
  { name: 'acetato' }

].each do |hash|
  Material.find_or_create_by(hash)
end

plegadizo = Material.where(name: ['reverso gris', 'reverso blanco', 'caple', 'multicapa', 'sulfatada'])
liner = Material.where(name: 'liner')
corrugado = Material.where(name: 'corrugado')
doble_corrugado = Material.where(name: 'doble corrugado')

[
  { name: '12 pts' },
  { name: '14 pts' },
  { name: '16 pts' },
  { name: '18 pts' },
  { name: '20 pts' },
  { name: '22 pts' },
  { name: '24 pts' },
  { name: '170 grs' },
  { name: '180 grs' },
  { name: '275 grs' },
  { name: '300 grs' },
  { name: 'SG - 20 ECT' },
  { name: '7kg - 23 ECT' },
  { name: '9kg - 26 ECT' },
  { name: '11kg - 29 ECT' },
  { name: '12kg - 32 ECT' },
  { name: '14kg - 40 ECT' },
  { name: '16kg - 44 ECT' },
  { name: '18kg - 51 ECT' },
  { name: '12kg - 36 ECT DC' },
  { name: '14kg - 42 ECT DC' },
  { name: '19kg - 48 ECT DC' },
  { name: '25kg - 51 ECT DC' },
  { name: '28kg - 61 ECT DC' },
  { name: '35kg - 71 ECT DC' },
  { name: '42kg - 82 ECT DC' }

].each do |hash|
  Resistance.find_or_create_by(hash)
end

r_plegadizo = Resistance.where("name LIKE ?", "%pts%")
r_liner = Resistance.where("name LIKE ?", "%grs%")
r_corrugado = Resistance.where("name LIKE ? AND name NOT LIKE ?", "%ECT%", "%DC%")
r_d_corrugado = Resistance.where("name LIKE ? AND name LIKE ?", "%ECT%", "%DC%")

plegadizo.each do |material|
  r_plegadizo.each do |resistance|
    material.resistances << resistance
  end
end

liner.each do |material|
  r_liner.each do |resistance|
    material.resistances << resistance
  end
end

corrugado.each do |material|
  r_corrugado.each do |resistance|
    material.resistances << resistance
  end
end

doble_corrugado.each do |material|
  r_d_corrugado.each do |resistance|
    material.resistances << resistance
  end
end

[
  { name: 'hogar' },
  { name: 'oficina'},
  { name: 'alimentos y regalos' },
  { name: 'empaque y embalaje' },
  { name: 'ecológica' },
  { name: 'exhibidores' },
  { name: 'diseños especiales' }

].each do |hash|
  Classification.find_or_create_by(hash)
end

[
  { name: 'kraft' },
  { name: 'bond' }

].each do |hash|
  InteriorColor.find_or_create_by(hash)
  ExteriorColor.find_or_create_by(hash)
end

[
  { name: 'Muñeca'},
  { name: 'Regalo'},
  { name: 'Regalo con ventana'},
  { name: 'Lonchera'},
  { name: 'Caja regular CR'},
  { name: 'Maletín'},
  { name: 'Cierre automático'},
  { name: 'Medicina o perfume'},
  { name: 'Pizza'}

].each do |hash|
  DesignLike.find_or_create_by(hash)
end

[
  { name: 'Barniz a registro' },
  { name: 'Barniz de máquina' },
  { name: 'Barniz UV' },
  { name: 'Plastificado mate' },
  { name: 'Plastificado brillante' },
  { name: 'Hot stamping' }

].each do |hash|
  Finishing.find_or_create_by(hash)
end

[
  { key: 'I', description: 'Ingreso' },
  { key: 'E', description: 'Egreso' },
  { key: 'T', description: 'Traslado' },
  { key: 'N', description: 'Nómina' },
  { key: 'P', description: 'Pago' }

].each do |hash|
  TypeOfBill.find_or_create_by(hash)
end

[
  { key: 001, description: 'ISR', retention: true, transfer: false },
  { key: 002, description: 'IVA', retention: true, transfer: true, value: 16.0 },
  { key: 003, description: 'IEPS', retention: true, transfer: true }
].each do |hash|
  Tax.find_or_create_by(hash)
end

require 'csv'

Agrega el catálogo de Régimen fiscal del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'tax_regime.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
 t = TaxRegime.new
 t.tax_id = row['tax_id']
 t.description = row['description']
 t.particular = row['particular']
 t.corporate = row['corporate']
 t.date_since = row['date_since']
 t.save
 puts "#{t.id}, #{t.tax_id}, #{t.description} saved"
end

puts "There are now #{TaxRegime.count} rows in the Tax Regime table"

Agrega el catálogo de Forma de pago del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'payment_form.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
 t = PaymentForm.new
 t.payment_id = row['payment_id']
 t.description = row['description']
 t.save
 puts "#{t.id}, #{t.payment_id}, #{t.description} saved"
end

Agrega el catálogo de Método de pago del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'payment_method.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
 t = PaymentMethod.new
 t.method = row['method']
 t.description = row['description']
 t.save
 puts "#{t.id}, #{t.method}, #{t.description} saved"
end

Agrega el catálogo de Clave de productos del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'sat_key.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
 t = SatKey.new
 t.sat_key = row['sat_key']
 t.description = row['description']
 t.save
 puts "#{t.id}, #{t.sat_key}, #{t.description} saved"
end

Agrega el catálogo de Unidad de productos del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'sat_unit_key.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
 t = SatUnitKey.new
 t.unit = row['unit']
 t.description = row['description']
 t.save
 puts "#{t.id}, #{t.unit}, #{t.description} saved"
end

Agrega el catálogo del Código Postal de productos del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'sat_zipcode.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
 t = SatZipcode.new
 t.zipcode = row['zipcode']
 t.save
 puts "#{t.id}, #{t.zipcode} saved"
end

puts "There are now #{PaymentForm.count} rows in the Payment Form table"
puts "There are now #{PaymentMethod.count} rows in the Payment Method table"
puts "There are now #{SatKey.count} rows in the SAT Key table"
puts "There are now #{SatUnitKey.count} rows in the SAT Unit Key table"
puts "There are now #{SatZipcode.count} rows in the SAT ZipCode table"

# Agrega el catálogo de monedas del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'currency.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
t = Currency.new
t.name = row['name']
t.description = row['description']
t.decimals = row['decimals']
t.save
puts "#{t.id}, #{t.name} saved"
end

puts "There are now #{Currency.count} rows in the Currency table"

# Agrega el catálogo de países del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'country.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
t = Country.new
t.key = row['key']
t.name = row['name']
t.save
puts "#{t.id}, #{t.name} saved"
end

puts "There are now #{Country.count} rows in the Country table"

Agrega el catálogo de tipo de relaciones del CFDI del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'relation_type.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
t = RelationType.new
t.key = row['key']
t.description = row['description']
t.save
puts "#{t.id}, #{t.key} saved"
end

puts "There are now #{RelationType.count} rows in the Relation Type table"

Agrega el catálogo de uso de CFDI del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'cfdi_use.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
t = CfdiUse.new
t.key = row['key']
t.description = row['description']
t.save
puts "#{t.id}, #{t.key} saved"
end

puts "There are now #{CfdiUse.count} rows in the CFDI Use table"
