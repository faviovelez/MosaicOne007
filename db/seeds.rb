# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
{
  "store":            "store user",
  "manager":          "can assign price",
  "designer":         "can respond design requests",
  "director":         "can access all reports",
  "store-admin":      "can acces all sections of POS and reports",
  "manager-admin":    "can follow status of requests and orders",
  "wharehouse-staff": "can process orders and enter new production",
  "product-admin":    "can create products and assign product code and co..."
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
