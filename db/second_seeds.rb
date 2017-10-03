################# INICIA SECCIÓN SOLO PARA DESARROLLO #####################

# Esta parte es para usarla solo durante desarrollo
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

# Esta parte es para usarla solo durante desarrollo
if User.first.role.nil?

  User.first.update_attributes(role: Role.all.sample, store:  Store.all.sample)

  valids_users = User.where.not(id: User.first.id)

  2.times do
    valids_users.sample.update_attributes(role: Role.where(name: 'manager').first, store: Store.find(User.first.store_id))
  end

end

# Esta parte es para usarla solo durante desarrollo
User.where(role: nil).each do |user|
  user.update_attributes(role: Role.all.sample, store:  Store.all.sample)
end

# Esta parte es para usarla solo durante desarrollo
100.times do |n|
  Supplier.create(name: Faker::Name.name)
end
