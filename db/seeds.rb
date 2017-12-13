require 'csv'

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
BusinessGroup.find_or_create_by(
                                  { name: "Diseños de Cartón", business_group_type: 'main' }
                                )

# Se establece por default la configuración de tipo de costeo a PEPS en la tabla CostType
[
  { warehouse_cost_type: "PEPS", description: "Primeras entradas, primeras salidas"},
  { warehouse_cost_type: "UEPS", description: "Últimas entradas, primeras salidas"}
].each do |hash|
  CostType.find_or_create_by(hash)
end

default_cost_type = CostType.find_by_warehouse_cost_type('PEPS')

# Cada tienda debe pertenecer a un Business Unit y cada Business Unit debe pertenecer a un Business Group, se crean defaults para funcionalidad inicial que deben ser modificadas (y/o agregadas nuevas)
default_business_group = BusinessGroup.find_by_business_group_type('main')

[
  { name: "Diseños de Cartón", business_group: default_business_group, main: true },
  { name: "Comercializadora de Cartón y Diseño", business_group: default_business_group, main: true},
].each do |hash|
  BusinessUnit.find_or_create_by(hash)
end

patria_business_unit = BusinessUnit.find_by_name('Diseños de Cartón')
compresor_business_unit = BusinessUnit.find_by_name('Comercializadora de Cartón y Diseño')

# Se crea el modelo Store_type para los distintos tipos de tiendas. Al crear una tienda, se puede elegir entre los business_units default o los creados o modificados por los usuarios.
[
  { store_type: "tienda propia" },
  { store_type: "corporativo" },
  { store_type: "distribuidor" },
  { store_type: "franquicia" }
].each do |hash|
  StoreType.find_or_create_by(hash)
end

store_type_default = StoreType.find_by_store_type('corporativo')

cost_type = CostType.find_by_warehouse_cost_type('PEPS')

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

compresor_prospect = Prospect.find_or_create_by(
                            legal_or_business_name: default_store_compresor.store_name,
                            business_type: default_store_compresor.type_of_person,
                            prospect_type: 'comercialización de productos',
                            contact_first_name: default_store_compresor.contact_first_name,
                            contact_last_name: default_store_compresor.contact_last_name,
                            second_last_name: default_store_compresor.second_last_name,
                            direct_phone: default_store_compresor.direct_phone,
                            email: default_store_compresor.email,
                            store_code: default_store_compresor.store_code,
                            store_type: default_store_compresor.store_type,
                            store_prospect: default_store_compresor,
                            credit_days: 0,
                            business_unit: compresor_business_unit,
                            business_group: default_business_group
                            )

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

patria_prospect = Prospect.find_or_create_by(
                            legal_or_business_name: default_store_patria.store_name,
                            business_type: default_store_patria.type_of_person,
                            prospect_type: 'comercialización de productos',
                            contact_first_name: default_store_patria.contact_first_name,
                            contact_last_name: default_store_patria.contact_last_name,
                            second_last_name: default_store_patria.second_last_name,
                            direct_phone: default_store_patria.direct_phone,
                            email: default_store_patria.email,
                            store_code: default_store_patria.store_code,
                            store_type: default_store_patria.store_type,
                            store_prospect: default_store_patria,
                            credit_days: 0,
                            business_unit: compresor_business_unit,
                            business_group: default_business_group
                            )

# Se crean almacenes default
Warehouse.find_or_create_by(
                            warehouse_code: 'AG000',
                            name: 'Corrugado',
                            business_unit: compresor_business_unit,
                            business_group: default_business_group
                            )

Warehouse.find_or_create_by(
                            warehouse_code: 'AG001',
                            name: 'Caple',
                            business_unit: compresor_business_unit,
                            business_group: default_business_group
                            )

Warehouse.find_or_create_by(
                            warehouse_code: 'AG002',
                            name: 'Hechas a mano',
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
                                                  type_of_person: 'Persona Moral',
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
                                                            type_of_person: 'Persona Moral',
                                                            rfc: 'CCD000517IF0',
                                                            street: 'Roble',
                                                            exterior_number: '1297-A',
                                                            neighborhood: 'Del Fresno',
                                                            zipcode: 44900,
                                                            city: 'Guadalajara',
                                                            state: 'Jalisco',
                                                            country: 'México'
                                                            )

patria_supplier.update(delivery_address: patria_delivery)

comercializadora_supplier.update(delivery_address: comercializadora_delivery)

default_store_patria.update(delivery_address: patria_delivery)

default_store_compresor.update(delivery_address: comercializadora_delivery)

patria_business_unit.update(billing_address: patria_billing)

compresor_business_unit.update(billing_address: comercializadora_billing)

admin = Role.find_by_name('platform-admin')

unless User.find_by_email('admin@adminmosaictech.com').present?
  User.create(
               email: "admin@adminmosaictech.com",
               first_name: "Administrador",
               last_name: "Diseños de Cartón",
               password: ENV["admin_user_password"],
               password_confirmation: ENV["admin_user_password"],
               role: admin,
               store: default_store_compresor
               )
end

[
  { product_type: 'caja' },
  { product_type: 'bolsa' },
  { product_type: 'exhibidor' }

].each do |hash|
  ProductType.find_or_create_by(hash)
end

impression_types = [
  { name: '1' },
  { name: '2' },
  { name: '3' },
  { name: 'selección de color' },
  { name: 'serigrafía' },
  { name: 'plasta' }
]

impression_types.each do |hash|
  ImpressionType.find_or_create_by(hash)
end

materials = [
  { name: 'caple' },
  { name: 'sulfatada' },
  { name: 'multicapa' },
  { name: 'liner' }, # Este aplica para papel arroz
  { name: 'single face' }, # Este aplica para papel arroz
  { name: 'microcorrugado' },
  { name: 'corrugado' },
  { name: 'doble corrugado' },
  { name: 'cartón rígido' }, # Este no para acetato y celofán
  { name: 'papel bond' },
  { name: 'papel arroz' },
  { name: 'celofán' },
  { name: 'acetato' }
]

materials.each do |hash|
  Material.find_or_create_by(hash)
end

[
  { name: 'kraft' },
  { name: 'blanco' },
  { name: 'transparente' }

].each do |hash|
  InteriorColor.find_or_create_by(hash)
  ExteriorColor.find_or_create_by(hash)
end

[
  { name: 'calibre 10' },
  { name: 'calibre 12' },
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
  { name: 'flauta e' },
  { name: '20 ECT' },
  { name: '23 ECT' },
  { name: '26 ECT' },
  { name: '29 ECT' },
  { name: '32 ECT' },
  { name: '40 ECT' },
  { name: '44 ECT' },
  { name: '51 ECT' },
  { name: '36 ECT DC' },
  { name: '42 ECT DC' },
  { name: '48 ECT DC' },
  { name: '51 ECT DC' },
  { name: '61 ECT DC' },
  { name: '71 ECT DC' },
  { name: '82 ECT DC' }
].each do |hash|
  Resistance.find_or_create_by(hash)
end

designs = [
  { name: 'Muñeca'},
  { name: 'Regalo'},
  { name: 'Regalo con ventana'},
  { name: 'Lonchera'},
  { name: 'Caja regular CR'},
  { name: 'Maletín'},
  { name: 'Fondo automático'},
  { name: 'Fondo 123'},
  { name: 'Tipo crema'},
  { name: 'Tipo archivo'},
  { name: 'Charola para pegar'},
  { name: 'Charola armable'},
  { name: 'Medicina o perfume'},
  { name: 'Pizza'},
  { name: 'Bolsa'}
]

designs.each do |hash|
  DesignLike.find_or_create_by(hash)
end

finshings = [
  { name: 'Barniz' },
  { name: 'Mikelman' },
  { name: 'Barniz a registro' },
  { name: 'Barniz de máquina' },
  { name: 'Barniz UV' },
  { name: 'Plastificado mate' },
  { name: 'Plastificado brillante' },
  { name: 'Hot stamping' },
  { name: 'Encerado' },
  { name: 'Antiestático' }
]

finshings.each do |hash|
  Finishing.find_or_create_by(hash)
end


materials = Material.all
materials.each do |material|
  unless material.name == 'cartón rígido'
    material.children << Material.find_by_name('celofán')
    material.children << Material.find_by_name('acetato')
  end
  material.children << Material.find_by_name('papel arroz') if (material.name == 'liner' || material.name == 'single face')

  material.exterior_colors << ExteriorColor.find_by_name('kraft') unless (material.name == 'papel bond' || material.name == 'acetato' || material.name == 'sulfatada' || material.name == 'multicapa' || material.name == 'caple')
  material.exterior_colors << ExteriorColor.find_by_name('blanco') unless (material.name == 'liner' || material.name == 'acetato')
  material.exterior_colors << ExteriorColor.find_by_name('transparente') if material.name == 'acetato'

  material.interior_colors << InteriorColor.find_by_name('transparente') if material.name == 'acetato'
  material.interior_colors << InteriorColor.find_by_name('kraft') unless (material.name == 'papel bond' || material.name == 'acetato' || material.name == 'sulfatada' || material.name == 'multicapa')
  material.interior_colors << InteriorColor.find_by_name('blanco') unless (material.name == 'liner' || material.name == 'cartón rígido' || material.name == 'acetato')

  designs = DesignLike.all
  designs.each do |design|
    unless material.name == 'cartón rígido'
      if (material.name == 'contraencolado' || material.name == 'corrugado' || material.name == 'doble corrugado')
        material.design_likes << design unless design.name == 'Bolsa'
      elsif material.name == 'papel bond'
        material.design_likes << design if design.name == 'Bolsa'
      elsif material.name == 'acetato'
        material.design_likes << design if (design.name == 'Muñeca' || design.name == 'Regalo' || design.name == 'Lonchera' || design.name == 'Fondo 123')
      else
        material.design_likes << design
      end
    end
  end

  finishings = Finishing.all
  finishings.each do |finishing|
    unless (material.name == 'single face' || material.name == 'cartón rígido' || material.name == 'acetato' || material.name == 'papel bond')
      if material.name == 'liner'
        material.finishings << finishing if finishing.name == 'Hot stamping'
      elsif material.name == 'microcorrugado'
        material.finishings << finishing if (finishing.name == 'Barniz' || finishing.name == 'Mikelman')
      elsif (material.name == 'corrugado' || material.name == 'doble corrugado')
        material.finishings << finishing if (finishing.name == 'Barniz' || finishing.name == 'Mikelman' || finishing.name == 'Encerado' || finishing.name == 'Antiestático')
      else
        material.finishings << finishing unless (finishing.name == 'Barniz' || finishing.name == 'Mikelman' || finishing.name == 'Encerado' || finishing.name == 'Antiestático')
      end
    end
  end
  impression_types = ImpressionType.all
  impression_types.each do |impression|
    unless (impression.name == 'plasta' || impression.name == 'selección de color' || impression.name == 'serigrafía')
      material.impression_types << impression unless material.name == 'acetato'
    end
  end
end

r_plegadizo = Resistance.where("name LIKE ?", "%pts%")
r_liner = Resistance.where("name LIKE ?", "%grs%")
r_corrugado = Resistance.where("name LIKE ? AND name NOT LIKE ?", "%ECT%", "%DC%")
r_d_corrugado = Resistance.where("name LIKE ? AND name LIKE ?", "%ECT%", "%DC%")
faluta_e = Resistance.find_by_name('flauta e')
calibres = Resistance.where("name LIKE ?", "%calibre%")
resistance_180 = Resistance.find_by_name('180 grs')

plegadizo = Material.where(name: ['caple', 'multicapa', 'sulfatada'])
liner = Material.where(name: 'liner')
corrugado = Material.where(name: 'corrugado')
doble_corrugado = Material.where(name: 'doble corrugado')
bond = Material.find_by_name('papel bond')
single = Material.find_by_name('single face')
acetato = Material.find_by_name('acetato')

bond.resistances << resistance_180
single.resistances << faluta_e
acetato.resistances << calibres

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

[
  { complexity: 'muy baja', cost: 200.00},
  { complexity: 'media', cost: 500.00},
  { complexity: 'muy alta', cost: 1000.00}

].each do |hash|
  DesignCost.find_or_create_by(hash)
end

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
                                )
  puts "#{t.id}, #{t.tax_id}, #{t.description} saved"
end

puts "There are now #{TaxRegime.count} rows in the Tax Regime table"

# Agrega el catálogo de Forma de pago del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'payment_form.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  t = PaymentForm.find_or_create_by(
                                    {
                                      payment_key: row['payment_id'],
                                      description: row['description']
                                    }
                                  )
  puts "#{t.id}, #{t.payment_key}, #{t.description} saved"
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
                                    )
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
                             )
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

# Agrega el catálogo de países del SAT
csv_text = File.read(Rails.root.join('lib', 'seeds', 'country.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  t = Country.find_or_create_by(
                                {
                                  key: row['key'],
                                  name: row['name']
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

####### FALTA COMPLETAR LOS CAMPOS DE STORE #######
# Agrega el catálogo de Tiendas de Diseños de Cartón
csv_text = File.read(Rails.root.join('lib', 'seeds', 'datosparacrearunatiendafinal.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')

csv.each do |row|
  store = Store.find_or_create_by(
                                    {
                                      store_type: StoreType.find_by_store_type(row['tipo_de_tienda']),
                                      store_name: row['nombre_de_la_tienda'],
                                      store_code: '0' + (Store.last.id + 1).to_s,
                                      business_group: BusinessGroup.find_or_create_by(name: row['grupo_de_negocios']),
                                      business_unit: BusinessUnit.find_or_create_by(name: row['empresa'], business_group: BusinessGroup.find_or_create_by(name: row['grupo_de_negocios'])),
                                      contact_first_name: row['primer_nombre'],
                                      contact_middle_name: row['segundo_nombre'],
                                      contact_last_name: row['apellido_paterno'],
                                      second_last_name: row['apellido_materno'],
                                      direct_phone: row['tel_fijo'],
                                      cell_phone: row['celular'],
                                      cost_type: CostType.find_by_warehouse_cost_type('PEPS'),
                                      cost_type_selected_since: Date.today,
                                      zip_code: row['zipcode'],
                                      overprice: row['sobreprecio'],
                                      email: row['correo'],
                                      type_of_person: row['tipo_de_persona']
                                    }
                                  )

  warehouse_code = "AT" + store.store_code
  puts "#{store.id}, #{store.store_name} saved"
  prospect = Prospect.find_or_create_by(
                                        {
                                          legal_or_business_name: store.store_name,
                                          business_type: store.type_of_person,
                                          prospect_type: 'comercialización de productos',
                                          contact_first_name: store.contact_first_name,
                                          contact_middle_name: store.contact_middle_name,
                                          contact_last_name: store.contact_last_name,
                                          second_last_name: store.second_last_name,
                                          direct_phone: 1234567890,
                                          extension: store.extension,
                                          cell_phone: store.cell_phone,
                                          email: store.email,
                                          store_code: store.store_code,
                                          store_type: store.store_type,
                                          store_prospect: store,
                                          credit_days: 30,
                                          business_unit: BusinessUnit.find(1),
                                          business_group: BusinessGroup.find_by_business_group_type('main')
                                        }
                                       )

   Warehouse.find_or_create_by(
                               warehouse_code: warehouse_code,
                               name: "Almacén #{store.store_name}",
                               business_unit: store.business_unit,
                               business_group: store.business_group
                               )

  cash_register = CashRegister.find_or_create_by(
                                                 {
                                                   name: "1",
                                                   store: store,
                                                   balance: 0,
                                                   cash_number: 1
                                                 }
                                                )
  puts "#{prospect.id}, #{prospect.legal_or_business_name} saved"

end

stores = Store.all.order(:created_at)
unless stores == nil
  stores.first.update(series: 'AA', last_bill: 0)
  last_series = stores.first.series
  stores.each do |s|
    s.update(series: last_series.next, last_bill: 0) unless s == stores.first
    last_series = s.series
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'formulariodeusuariosfinal.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|

  user = User.create(
               email: row['mail'],
               first_name: row['primer_nombre'],
               middle_name: row['segundo_nombre'],
               last_name: row['apellido_paterno'],
               password: row['password'],
               password_confirmation: row['password'],
               role: Role.find_by_name('store-admin'),
               store: Store.find_by_store_name(row['tienda'])
               )
end

def add_store_to_finkok(rfc)

  client = Savon.client(wsdl: ENV['add_dir']) do
    convert_request_keys_to :none
  end

  username = ENV['username_pac']
  password = ENV['password_pac']
  taxpayer_id = rfc #RFC Emisor
  #Envia la peticion al webservice de registro
  response = client.call(:add, message: { reseller_username: username, reseller_password: password, taxpayer_id: taxpayer_id  })

  #Obtiene el SOAP Request y guarda la respuesta en un archivo
  ops = client.operation(:add)
  request = ops.build( message: { reseller_username: username, reseller_password: password, taxpayer_id: taxpayer_id }).to_s
end

rfcs = []
csv_text = File.read(Rails.root.join('lib', 'seeds', 'informacionparaaltafacturacionfinal.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|

  billing = BillingAddress.find_or_create_by(
                                              {
                                                business_name: row['legal_name'],
                                                type_of_person: row['tipo_de_persona'],
                                                rfc: row['rfc'],
                                                street: row['calle'],
                                                exterior_number: row['num_ext'],
                                                interior_number: row['num_int'],
                                                neighborhood: row['colonia'],
                                                zipcode: row['zipcode'],
                                                city: row['ciudad'],
                                                state: row['estado'],
                                                country: row['country'],
                                                tax_regime: TaxRegime.find_by_description(row['regime'])
                                              }
                                            )

  Store.find_by_store_name(row['store']).business_unit.update(billing_address: billing)
  rfcs << row['rfc']
end

rfcs.each do |rfc|
  add_store_to_finkok(rfc)
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'informaciondirecciondeentrega.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|

  delivery = DeliveryAddress.find_or_create_by(
                                              {
                                                street: row['calle'],
                                                exterior_number: row['num_ext'],
                                                interior_number: row['int_num'],
                                                neighborhood: row['colonia'],
                                                zipcode: row['zipcode'],
                                                city: row['ciudad'],
                                                state: row['estado'],
                                                country: row['country'],
                                                additional_references: row['referencias_adicionales']
                                              }
                                            )
  store_new = Store.find_by_store_name(row['tienda'])
  store_new.update(delivery_address: delivery)
end

# Agrega el catálogo de Servicios de Diseños de Cartón
csv_text = File.read(Rails.root.join('lib', 'seeds', 'services.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  service = Service.find_or_create_by(
                                        {
                                          sat_key: SatKey.find_by_sat_key(row['sat_key']),
                                          unique_code: row['unique_code'],
                                          description: row['description'],
                                          business_unit: BusinessUnit.find_by_name(row['business_unit']),
                                          delivery_company: row['delivery_company'],
                                          sat_unit_key: SatUnitKey.find_by_unit(row['sat_unit_key']),
                                          price: row['price'],
                                          current: true,
                                          shared: true
                                        }
                                      )
end

# Agrega el catálogo de Productos de Diseños de Cartón
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
                                          outer_length: row['outer_length'],
                                          inner_length: row['inner_length'],
                                          price: row['price'],
                                          factor: row['factor'],
                                          average: row['average'],
                                          discount_for_franchises: row['stores_discount'],
                                          discount_for_stores: row['retails_discount'],
                                          armed_discount: row['discount_when_armed'],
                                          current: true,
                                          shared: true
                                        }
                                      )

  if row['impression'] == 'sí'
    product.update(impression: true)
  else
    product.update(impression: false)
  end

  not_armed = (row['discount_when_armed'] == '' || row['discount_when_armed'] == nil)
  product.update(armed: true, armed_discount: row['discount_when_armed']) unless not_armed

  puts "#{product.id}, #{product.unique_code} saved"
  i = Inventory.find_or_create_by(
                                    {
                                      product: product,
                                      unique_code: product.unique_code
                                    }
                                  )
  puts "#{i.id}, #{i.unique_code} saved"

# Crea masivamente los stores inventories para todas las tiendas excepto corporativo
  corporate = StoreType.find_by_store_type('corporativo')
  stores = Store.where.not(store_type: corporate)
  if product.classification != 'especial'
    stores.each do |store|
      StoresInventory.find_or_create_by(product: product, store: store)
    end
  end
end

Product.find_by_unique_code('4201').update(parent: Product.find_by_unique_code('4200'))
Product.find_by_unique_code('4200').update(child: Product.find_by_unique_code('4201'))
Product.find_by_unique_code('4223').update(parent: Product.find_by_unique_code('4224'))
Product.find_by_unique_code('4224').update(child: Product.find_by_unique_code('4223'))

stores = [
  'Avenida México',
  'Ávila Camacho',
  'Bugambilias',
  'Calzada',
  'Durango',
  'Lopez Mateos',
  'Olímpica',
  'Patria',
  'Guadalupe',
  'Puerto Vallarta',
  'Río Nilo',
  'Santa Tere',
  'Toluca',
  'Tonalá',
  'Valle Real'
]

prospect_files = [
  'LayOutClientesAvenidaMexico',
  'LayOutClientesAvilaCamacho',
  'LayOutClientesBugambilias',
  'LayOutClientesCalzada',
  'LayOutClientesDurango',
  'LayOutClientesLopezMateos',
  'LayOutClientesOlimpica',
  'LayOutClientesPatria',
  'LayOutClientesPlazaGuadalupe',
  'LayOutClientesPuertoVallarta',
  'LayOutClientesRioNilo',
  'LayOutClientesSantateresita',
  'LayOutClientesToluca',
  'LayOutClientesTonala',
  'LayOutClientesJardinReal'
]

stores_with_cert = [
  'Avenida México',
  'Ávila Camacho',
  'Bugambilias',
  'Calzada',
  'Circunvalación',
  'Clouthier',
  'Corporativo Compresor',
  'Corporativo Patria',
  'Cuautitlán',
  'Guadalupe NL',
  'Valle Real',
  'Lapizlázuli',
  'Lopez Mateos',
  'Patria',
  'Guadalupe',
  'Puerto Vallarta',
  'Río Nilo',
  'Roble',
  'San Juan Bosco',
  'Santa Tere',
  'Tonalá',
  'Aguascalientes'
]

directories = [
  'avenida_mexico',
  'avila_camacho',
  'bugambilias',
  'calzada',
  'circunvalacion',
  'clouthier',
  'corporativo_compresor',
  'corporativo_patria',
  'cuautitlan',
  'guadalupe_n_l',
  'jardin_real',
  'lapizlazuli',
  'lopez_mateos',
  'patria',
  'plaza_guadalupe',
  'puerto_vallarta',
  'rio_nilo',
  'roble',
  'san_juan_bosco',
  'santa_tere',
  'tonala',
  'aguascalientes'
]

pss = [
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'Sc123456',
  'Sc123456',
  'Sc123456',
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'd1234567',
  'bafio44741'
]

def get_certificate_number
  file = File.join(Rails.root, "public", "uploads", "store", "#{@store.id}", "certificate", "cer.cer")
  serial = `openssl x509 -inform DER -in #{file} -noout -serial`
  n = serial.slice(7..46)
  @certificate_number = ''
  x = 1
  for i in 0..n.length
    if x % 2 == 0
      @certificate_number << n[i]
    end
    x += 1
  end
  @certificate_number
end

def save_certificate_number
  get_certificate_number
  @store.update(certificate_number: @certificate_number)
end

def save_certificate_content
  @cer_file = Rails.root.join('public', 'uploads', 'store', "#{@store.id}", 'certificate', 'cer.cer')
  b64 = Base64.encode64(File::read(@cer_file))
  clean = b64.gsub("\n",'')
  @store.update(certificate_content: clean)
end

def save_pem_certificate
  File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cer.cer.pem"), "w") do |file|
    file.write('')
  end

  cer_pem = Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cer.cer.pem")
  `openssl x509 -inform DER -outform PEM -in #{@cer_file} -pubkey -out #{cer_pem}`
end

def save_base64_encrypted_cer
  file = File.read(Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cer.cer.pem"))
  cer_b64 = Base64.encode64(file)

  File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cerb64.cer.pem"), "w") do |file|
    file.write(cer_b64)
  end
end

def save_der_certificate
  File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cer.der"), "w") do |file|
    file.write('')
  end

  cer_der = Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cer.der")

  `openssl x509 -outform der -in #{cer_pem} -out #{cer_der}`
end

def save_pem_key
  file = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.key")
  password = @store.certificate_password

  File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.pem"), "w") do |file|
    file.write('')
  end

  key_pem = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.pem")
  `openssl pkcs8 -inform DER -in #{file} -passin pass:#{password} -out #{key_pem}`
end

def save_encrypted_key
  file = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.pem")
  password = ENV['password_pac']

  File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.enc.pem"), "w") do |file|
    file.write('')
  end

  enc = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.enc.key")

  `openssl rsa -in #{file} -des3 -out #{enc} -passout pass:"#{password}"`
end

def save_base64_encrypted_key
  file = File.read(Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.enc.key"))
  key_b64 = Base64.encode64(file)

  File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "keyb64.enc.key"), "w") do |file|
    file.write(key_b64)
  end
end

def save_unencrypted_key
  file = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.enc.key")
  password = ENV['password_pac']

  File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "new_key.pem"), "w") do |file|
    file.write('')
  end

  new_pem = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "new_key.pem")

  `openssl rsa -in #{file} -passin pass:"#{password}" -out #{new_pem}`
end

stores_with_cert.each_with_index do |val, index|
  cer = File.open(File.join(Rails.root, 'public', 'stores_cert_and_keys', "#{directories[index]}", 'cer.cer'), 'r')
  key = File.open(File.join(Rails.root, 'public', 'stores_cert_and_keys', "#{directories[index]}", 'key.key'), 'r')
  @store = Store.find_by_store_name(stores_with_cert[index])
  @store.update(certificate: cer, key: key, certificate_password: pss[index])
  save_certificate_number
  save_certificate_content
  save_pem_certificate
  save_pem_key
  save_encrypted_key
  save_unencrypted_key
end

stores.each_with_index do |val, index|
  csv_text = File.read(Rails.root.join('public', 'prospect_files', "#{prospect_files[index]}.csv"))
  csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')

  csv.each do |row|

    billing = BillingAddress.create(
                                    {
                                      business_name: row['nombre_de_empresa_o_cliente'],
                                      rfc: row['rfc'],
                                      street: row['calle'],
                                      exterior_number: row['num_ext'],
                                      interior_number: row['num_num'],
                                      zipcode: row['cod_postal'],
                                      neighborhood: row['colonia'],
                                      city: row['ciudad'],
                                      state: row['estado'],
                                      store: Store.find_by_store_name(stores[index])
                                    }
                                  )
    prospect = Prospect.find_or_create_by(
                                {
                                  legal_or_business_name: row['nombre_de_empresa_o_cliente'],
                                  prospect_type: row['giro'],
                                  contact_first_name: row['contacto_primer_nombre'],
                                  contact_middle_name: row['contacto_segundo_nombre'],
                                  contact_last_name: row['contacto_apellido_paterno'],
                                  second_last_name: row['contacto_apellido_materno'],
                                  contact_position: row['puesto_del_contacto'],
                                  direct_phone: row['tel_fijo'],
                                  extension: row['ext'],
                                  cell_phone: row['cel'],
                                  email: row['mail'],
                                  store: Store.find_by_store_name(stores[index]),
                                  billing_address: billing
                                }
                              )
  end
  s = Store.find_by_store_name(stores[index]).prospects.count
  puts "There are #{s} Prospects in #{stores[index]} Store"
end

puts "There are now #{Product.count} rows in the Products table"
puts "There are now #{Inventory.count} rows in the Inventory table"
puts "There are now #{StoresInventory.count} rows in the Stores Inventory table"
puts "There are now #{Store.count} rows in the Stores table"
puts "There are now #{Prospect.count} rows in the Prospects table"
puts "There are now #{CashRegister.count} rows in the Cash Registers table"
puts "There are now #{CfdiUse.count} rows in the CFDI Use table"
puts "There are now #{Currency.count} rows in the Currency table"
puts "There are now #{PaymentForm.count} rows in the Payment Form table"
puts "There are now #{PaymentMethod.count} rows in the Payment Method table"
puts "There are now #{SatKey.count} rows in the SAT Key table"
puts "There are now #{SatUnitKey.count} rows in the SAT Unit Key table"
puts "There are now #{SatZipcode.count} rows in the SAT ZipCode table"


Store.all.each do |store|
  billing_general_prospect = BillingAddress.find_or_create_by(
                                                                {
                                                                  business_name: 'Público en General',
                                                                  rfc: 'XAXX010101000',
                                                                  country: 'México',
                                                                  store: store
                                                                }
                                                              )

  general_prospect = Prospect.find_or_create_by(
                                      {
                                        legal_or_business_name: 'Público en General',
                                        prospect_type: 'público en general',
                                        contact_first_name: 'ninguno',
                                        contact_last_name: 'ninguno',
                                        direct_phone: 1111111111,
                                        store: store,
                                        store_prospect: nil,
                                        billing_address: billing_general_prospect
                                      }
                                    )

  billing_foreign_prospect = BillingAddress.find_or_create_by(
                                                                {
                                                                  business_name: 'Residente en el extranjero',
                                                                  rfc: 'XEXX010101000',
                                                                  country: '',
                                                                  store: store
                                                                }
                                                              )

  foreign_prospect = Prospect.find_or_create_by(
                                      {
                                        legal_or_business_name: 'Residente en el extranjero',
                                        prospect_type: 'residente en el extranjero',
                                        contact_first_name: 'ninguno',
                                        contact_last_name: 'ninguno',
                                        direct_phone: 1111111111,
                                        store: store,
                                        store_prospect: nil,
                                        billing_address: billing_foreign_prospect
                                      }
                                    )
end
