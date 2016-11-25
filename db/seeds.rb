100.times {Restaurant.create(name:Faker::Name.name, latitude:Faker::Address.latitude,longitude:Faker::Address.longitude) }

1000.times {Food.create(restaurant_id: Restaurant.all.ids.sample,name:Faker::Pokemon.name,price:Faker::Number.between(100, 1000)) }