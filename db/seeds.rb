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

[
  { store_type: "franquicia", store_code: "000", store_name: "aguascalientes", discount: 0.2 },
  { store_type: "tienda", store_code: "001", store_name: "diseños de carton", discount: 0.5 },
  { store_type: "tienda propia", store_code: "003", store_name: "calzada", discount: 35.0 },
  { store_type: "tienda propia", store_code: "003", store_name: "calzada", discount: 0.35 }
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
