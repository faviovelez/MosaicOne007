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
  "warehouse-admin": "Maneja inventario, órdenes de producción, prepara pedidos y crea usuarios wharehouse-staff",
  "warehouse-staff": "Maneja inventario, órdenes de producción, prepara pedidos",
  "admin-desk":       "Crea usuarios tipo drivers, crea envíos y factura, elabora pedidos y cotizaciones",
  "designer-admin":   "Da respuesta a las solicitudes de diseño y puede crear usuarios designer",
  "designer":         "Da respuesta a las solicitudes de diseño",
  "driver":           "Entrega mercancía",
  "viewer":           "Da seguimiento a pedidos y cotizaciones"
}.each do |name, description|
  Role.find_or_create_by(name: name, description: description)
end

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
default = BusinessGroup.find_by_name('default compañía')
default_terceros = BusinessGroup.find_by_name('default terceros')

[
  { name: "default compañía", business_group: default},
  { name: "default terceros", business_group: default_terceros}
].each do |hash|
  BusinessUnit.find_or_create_by(hash)
end

# Se crea el modelo Store_type para los distintos tipos de tiendas. Al crear una tienda, se puede elegir entre los business_units default o los creados o modificados por los usuarios.
[
  { store_type: "tienda propia", business_unit: default },
  { store_type: "corporativo", business_unit: default },
  { store_type: "distribuidor", business_unit: default_terceros },
  { store_type: "franquicia", business_unit: default_terceros }
].each do |hash|
  StoreType.find_or_create_by(hash)
end

[
  { store_type: "tienda propia", store_code: "003", store_name: "calzada", discount: 0.0 },
  { store_type: "corporativo", store_code: "003", store_name: "calzada", discount: 0.0 },
  { store_type: "distribuidor", store_code: "003", store_name: "calzada", discount: 0.0 },
  { store_type: "franquicia", store_code: "000", store_name: "aguascalientes", discount: 0.0 }
].each do |hash|
  Store.find_or_create_by(hash)
end

if User.first.nil?
  20.times do |n|
    password = Faker::Internet.password(10, 20, true, true)
    User.create(
      email: Faker::Internet.email,
      first_name: Faker::Name.name,
      middle_name: Faker::Name.name,
      last_name: Faker::Name.last_name,
      password: password,
      password_confirmation: password
    )
  end
end

if User.first.role.nil?

  User.first.update_attributes(role: Role.all.sample, store:  Store.all.sample)

  valids_users = User.where.not(id: User.first.id)

  2.times do
    valids_users.sample.update_attributes(role: Role.where(name: 'manager').first, store: Store.find(User.first.store_id))
  end

end

User.where(role: nil).each do |user|
  user.update_attributes(role: Role.all.sample, store:  Store.all.sample)
end
