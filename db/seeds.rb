# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
{
  "platform-admin":   "Crea usuarios de todos los tipos, actualiza formularios",
  "director":         "Tiene acceso a todos los procesos y funciones de manager, puede crear usuarios manager",
  "manager":          "Asigna precio a cotizaciones y puede asignar costo a las entradas de materiales",
  "store":            "Crea prospectos, cotizaciones y pedidos, autoriza, cancela o reactiva cotizaciones y pedidos",
  "store-admin":      "Con acceso a todas las secciones, reportes y funcionalidades de tienda y puede crear usuarios store",
  "product-admin":    "Crea y modifica productos, asigna costos a entradas de mercancías, crea usuarios product-staff",
  "product-staff":    "Crea y modifica productos, asigna costos a entradas de mercancías",
  "warehouse-admin":  "Maneja inventario, órdenes de producción, prepara pedidos y crea usuarios wharehouse-staff",
  "warehouse-staff":  "Maneja inventario, órdenes de producción, prepara pedidos",
  "admin-desk":       "Crea usuarios tipo drivers, crea envíos y factura, elabora pedidos y cotizaciones",
  "designer-admin":   "Da respuesta a las solicitudes de diseño y puede crear usuarios designer",
  "designer":         "Da respuesta a las solicitudes de diseño",
  "driver":           "Entrega mercancía",
  "viewer":           "Da seguimiento a pedidos y cotizaciones"
}.each do |name, description|
  Role.find_or_create_by(name: name, description: description)
end

#### CONFIRMAR CON EL CLIENTE CUÁNTOS MÁS TIPOS DE USUARIO SE CREARÁN Y SI ESTÁ DE ACUERDO CON LOS NOMBRES ####
[
  {name: "platform-admin", translation: "administrador de plataforma", description: "Crea usuarios de todos los tipos, actualiza formularios" },
<<<<<<< 6683b6c959b982a56367e0b48a11d5ec23da07b8
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
] ####### Comentar esta línea cuando esté listo ##### y descomentar las 3 líneas siguientes.
=======
  {name: "director", translation: "director", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "manager", translation: "gerente", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "store", translation: "auxiliar de tienda", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "store-admin", translation: "jefe de tienda", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "product-admin", translation: "jefe de producto", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "product-staff",  translation: "auxiliar de producto", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "warehouse-admin", translation: "jefe de almacén", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "warehouse-staff", translation: "auxiliar de almacén", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "admin-desk", translation: "administrativo", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "designer-admin", translation: "jefe de diseñadores", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "designer", translation: "diseñador", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "driver", translation: "chofer", description: "Crea usuarios de todos los tipos, actualiza formularios" },
  {name: "viewer", translation: "soporte", description: "Crea usuarios de todos los tipos, actualiza formularios" }
]
>>>>>>> added suppliers
#].each do |hash|
#  Role.find_or_create_by(hash)
#end

# Deben existir por lo menos dos Business Groups: Uno para tiendas propias y otro para tiendas externas
[
  { name: "default compañía" },
  { name: "default terceros" }
].each do |hash|
  BusinessGroup.find_or_create_by(hash)
end

# Se establece por default la configuración de tipo de costeo a PEPS en la tabla CostType
[
  { warehouse_cost_type: "PEPS", description: "Primeras entradas, primeras salidas", selected: true },
  { warehouse_cost_type: "UEPS", description: "Últimas entradas, primeras salidas", selected: false }
].each do |hash|
  CostType.find_or_create_by(hash)
end

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

# Se crea un almacén default
Warehouse.create(warehouse_code: 'AG000', name: 'almacén default', business_unit: default_business_unit)

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

admin = Role.find_by_name('platform-admin')

User.find_or_create_by(
  email: "admin@adminmosaictech.com",
  first_name: "Administrador",
  last_name: "Diseños de Cartón",
<<<<<<< 7d7cb802c2bf6765c44951b9ed3c0752ca77b698
  password: ENV["admin_user_password"],
  password_confirmation: ENV["admin_user_password"],
=======
>>>>>>> changes for better mobile display
  role: admin,
  password: ENV["admin_user_password"],
  password_confirmation: ENV["admin_user_password"],
  role: master_user,
  store: default_store)

100.times do |n|
  Supplier.create(name: Faker::Name.name)
end
