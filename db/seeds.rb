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
  { name: "Diseños de Cartón", business_group_type: 'main' },
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
default_business_group = BusinessGroup.find_by_name('Diseños de Cartón')
default_terceros_business_group = BusinessGroup.find_by_name('default terceros')

[
  { name: "Diseños de Cartón", business_group: default_business_group, main: true },
  { name: "Comercializadora de Carton y Diseño", business_group: default_business_group, main: true},
  { name: "default terceros", business_group: default_terceros_business_group}
].each do |hash|
  BusinessUnit.find_or_create_by(hash)
end

patria_business_unit = BusinessUnit.find_by_name('Diseños de Cartón')
compresor_business_unit = BusinessUnit.find_by_name('Comercializadora de Cartón y Diseño')
default_terceros_business_unit = BusinessUnit.find_by_name('default terceros')

# Se crea el modelo Store_type para los distintos tipos de tiendas. Al crear una tienda, se puede elegir entre los business_units default o los creados o modificados por los usuarios.
[
  { store_type: "tienda propia" },
  { store_type: "corporativo" },
  { store_type: "distribuidor", business_unit_id: default_terceros_business_unit },
  { store_type: "franquicia", business_unit_id: default_terceros_business_unit }
].each do |hash|
  StoreType.find_or_create_by(hash)
end

store_type_default = StoreType.find_by_store_type('corporativo')

cost_type = CostType.find_by_warehouse_cost_type('PEPS')

default_store_patria = Store.find_or_create_by(
                                                store_name: 'Corporativo Patria',
                                                store_code: '000',
                                                store_type: store_type_default,
                                                type_of_person: 'persona moral',
                                                business_unit: patria_business_unit,
                                                business_group: default_business_group,
                                                cost_type: cost_type,
                                                cost_type_selected_since: Date.today,
                                                contact_first_name: 'Herminia',
                                                contact_last_name: 'Diseños de Cartón',
                                                direct_phone: '3336733339',
                                                zip_code: '45027',
                                                email: 'facturaspatria@disenosdecarton.com.mx'
                                                )

default_store_compresor = Store.find_or_create_by(
                                                  store_name: 'Corporativo Compresor',
                                                  store_code: '001',
                                                  store_type: store_type_default,
                                                  type_of_person: 'persona moral',
                                                  business_unit: compresor_business_unit,
                                                  business_group: default_business_group,
                                                  cost_type: cost_type,
                                                  cost_type_selected_since: Date.today,
                                                  contact_first_name: 'Bertha',
                                                  contact_last_name: 'Reynoso',
                                                  direct_phone: '3331621401',
                                                  zip_code: '44490',
                                                  email: 'facturacion1@disenosdecarton.com.mx'
                                                  )

# Se crean almacenes default
Warehouse.find_or_create_by(
                            warehouse_code: 'AG000',
                            name: 'Almacén General Patria',
                            business_unit: patria_business_unit,
                            business_group: default_business_group
                            )

Warehouse.find_or_create_by(
                            warehouse_code: 'AG001',
                            name: 'Almacén General Compresor',
                            business_unit: compresor_business_unit,
                            business_group: default_business_group
                            )

dc = {
      type_of_person: 'persona moral',
      business_type: 'comercialización de productos',
      supplier_status: 'activo',
      }

patria_supplier = Supplier.find_or_create_by(
                                              name: 'Diseños de Cartón',
                                              type_of_person: dc[:type_of_person],
                                              business_type: dc[:business_type],
                                              contact_first_name: 'Herminia',
                                              contact_last_name: 'Diseños de Cartón',
                                              email: 'guadalajara@disenosdecarton.com',
                                              supplier_status: dc[:supplier_status],
                                              direct_phone: '3336733339',
                                              contact_position: 'Asistente de Dirección'
                                              )

comercializadora_supplier = Supplier.find_or_create_by(
                                                        name: 'Comercializadora de Cartón y Diseño',
                                                        type_of_person: dc[:type_of_person],
                                                        business_type: dc[:business_type],
                                                        contact_first_name: 'Bertha',
                                                        contact_last_name: 'Reynoso',
                                                        email: 'gfranquicias@disenosdecarton.com',
                                                        supplier_status: dc[:supplier_status],
                                                        direct_phone: '3331621401',
                                                        contact_position: 'Gerente de franquicias'
                                                        )

patria_billing = BillingAddress.find_or_create_by(
                                                  business_name: 'Diseños de Cartón S.A. de C.V.',
                                                  rfc: 'DCA8603175G2',
                                                  street: 'Av. de la Patria',
                                                  exterior_number: '124',
                                                  neighborhood: 'Jardines Vallarta',
                                                  zipcode: 45027,
                                                  city: 'Zapopan',
                                                  state: 'Jalisco',
                                                  country: 'México'
                                                  )

patria_delivery = DeliveryAddress.find_or_create_by(
                                                    street: 'Av. de la Patria',
                                                    exterior_number: '124',
                                                    neighborhood: 'Jardines Vallarta',
                                                    zipcode: '45027',
                                                    city: 'Zapopan',
                                                    state: 'Jalisco',
                                                    country: 'México'
                                                    )

comercializadora_delivery = DeliveryAddress.find_or_create_by(
                                                              street: 'Compresor',
                                                              exterior_number: '2248',
                                                              neighborhood: 'Álamo Industrial',
                                                              zipcode: '44490',
                                                              city: 'Guadalajara',
                                                              state: 'Jalisco',
                                                              country: 'México'
                                                              )

comercializadora_billing = BillingAddress.find_or_create_by(
                                                            business_name: 'Comercializadora de Cartón y Diseño S.A. de C.V.',
                                                            rfc: 'CCD000517IF0',
                                                            street: 'Roble',
                                                            exterior_number: '1297-A',
                                                            neighborhood: 'del Fresno',
                                                            zipcode: 44900,
                                                            city: 'Guadalajara',
                                                            state: 'Jalisco',
                                                            country: 'México'
                                                            )
patria_supplier.update(delivery_address: patria_delivery)

comercializadora_supplier.update(delivery_address: comercializadora_delivery)

default_store_patria.update(delivery_address: patria_delivery)

default_store_compresor.update(delivery_address: comercializadora_delivery)

default_store_patria.update(billing_address: patria_billing)

default_store_compresor.update(billing_address: comercializadora_billing)

admin = Role.find_by_name('platform-admin')

User.create(
             email: "admin@adminmosaictech.com",
             first_name: "Administrador",
             last_name: "Diseños de Cartón",
             password: ENV["admin_user_password"],
             password_confirmation: ENV["admin_user_password"],
             role: admin,
             store: default_store_compresor
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
    material.resistances << resistance unless material.resistances.include?(resistance)
  end
end

liner.each do |material|
  r_liner.each do |resistance|
    material.resistances << resistance unless material.resistances.include?(resistance)
  end
end

corrugado.each do |material|
  r_corrugado.each do |resistance|
    material.resistances << resistance unless material.resistances.include?(resistance)
  end
end

doble_corrugado.each do |material|
  r_d_corrugado.each do |resistance|
    material.resistances << resistance unless material.resistances.include?(resistance)
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

# Agrega el catálogo de Régimen fiscal del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'tax_regime.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  t = TaxRegime.find_or_create_by(
                                  {
                                    tax_id: row['tax_id'],
                                    description: row['description'],
                                    particular: row['particular'],
                                    corporate: row['corporate'],
                                    date_since: row['date_since']
                                  }
  puts "#{t.id}, #{t.tax_id}, #{t.description} saved"
end

puts "There are now #{TaxRegime.count} rows in the Tax Regime table"

# Agrega el catálogo de Forma de pago del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'payment_form.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  t = PaymentForm.find_or_create_by(
                                    {
                                      payment_id: row['payment_id'],
                                      description: row['description']
                                    }
  puts "#{t.id}, #{t.payment_id}, #{t.description} saved"
end

# Agrega el catálogo de Método de pago del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'payment_method.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  t = PaymentMethod.find_or_create_by(
                                      {
                                        method:row['method'],
                                        description: row['description']
                                      }
  puts "#{t.id}, #{t.method}, #{t.description} saved"
end

# Agrega el catálogo de Clave de productos del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'sat_key.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  t = SatKey.find_or_create_by(
                               {
                                 sat_key: row['sat_key'],
                                 description: row['description']
                               }
  puts "#{t.id}, #{t.sat_key}, #{t.description} saved"
end

# Agrega el catálogo de Unidad de productos del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'sat_unit_key.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  t = SatUnitKey.find_or_create_by(
                                    {
                                      unit: row['unit'],
                                      description: row['description']
                                    }
                                  )
  puts "#{t.id}, #{t.unit}, #{t.description} saved"
end

# Agrega el catálogo del Código Postal de productos del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'sat_zipcode.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  t = SatZipcode.find_or_create_by(
                                    {
                                      zipcode: row['zipcode']
                                    }
                                  )
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
  t = Currency.find_or_create_by(
                                  {
                                    name: row['name'],
                                    description: row['description'],
                                    decimals: row['decimals']
                                  }
                              )
  puts "#{t.id}, #{t.name} saved"
end

puts "There are now #{Currency.count} rows in the Currency table"

# Agrega el catálogo de países del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'country.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  t = Country.find_or_create_by(
                                {
                                  key: row['key'],
                                  description: row['name']
                                }
                              )
  puts "#{t.id}, #{t.name} saved"
end

puts "There are now #{Country.count} rows in the Country table"

# Agrega el catálogo de tipo de relaciones del CFDI del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'relation_type.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  t = RelationType.find_or_create_by(
                                      {
                                        key: row['key'],
                                        description: row['description']
                                      }
                                    )
  puts "#{t.id}, #{t.key} saved"
end

puts "There are now #{RelationType.count} rows in the Relation Type table"

# Agrega el catálogo de uso de CFDI del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'cfdi_use.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  t = CfdiUse.find_or_create_by(
                                  {
                                    key: row['key'],
                                    description: row['description']
                                  }
                                )
  puts "#{t.id}, #{t.key} saved"
end

puts "There are now #{CfdiUse.count} rows in the CFDI Use table"

# Agrega el catálogo de Productos de Diseños de Cartón
csv_text = File.read(Rails.root.join('lib', 'seeds', 'products_trial.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  product = Product.find_or_create_by(
                                        {
                                          unique_code: row['cod'],
                                          description: row['desc'],
                                          business_unit: BusinessUnit.find_by_name(row['bu']),
                                          supplier: Supplier.find_by_name(row['bu']),
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
