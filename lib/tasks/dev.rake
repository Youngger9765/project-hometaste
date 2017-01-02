namespace :dev do

  desc "Rebuild system"
  task :rebuild => ["db:drop", "db:setup", :fake, :count_order_amount]

  task :fake => :environment do

  	# admin
    puts('create admin')

  	User.create(
  		name: "admin",
  		foodie_id: "admin",
  		email: "admin@admin.com",
  		phone_number: Faker::PhoneNumber.cell_phone,
  		password: 12345678,
  		confirmed_at: Faker::Time.between(DateTime.now - 365, DateTime.now-1),
  		address: Faker::Address.city + Faker::Address.street_name + Faker::Address.secondary_address,
  		is_chef: false,
  		is_admin: true,
		)

		# chef
    puts('create chef')

  	User.create(
  		name: "chef",
  		foodie_id: "chef",
  		email: "chef@chef.com",
  		phone_number: Faker::PhoneNumber.cell_phone,
  		password: 12345678,
  		confirmed_at: Faker::Time.between(DateTime.now - 365, DateTime.now-1),
  		address: Faker::Address.city + Faker::Address.street_name + Faker::Address.secondary_address,
  		is_chef: true,
  		is_admin: false,
		)

		# purpleice9765@msn.com
    puts('create me')

  	User.create(
  		name: "young",
  		foodie_id: "young",
  		email: "purpleice9765@msn.com",
  		phone_number: Faker::PhoneNumber.cell_phone,
  		password: 12345678,
  		confirmed_at: Faker::Time.between(DateTime.now - 365, DateTime.now-1),
  		address: Faker::Address.city + Faker::Address.street_name + Faker::Address.secondary_address,
  		is_chef: false,
  		is_admin: true,
		)

  	# create users
    puts('create users')

  	100.times {
  		User.create(
	  		name: Faker::Name.name,
	  		foodie_id: Faker::Name.name,
	  		email: Faker::Internet.email,
	  		phone_number: Faker::PhoneNumber.cell_phone,
	  		password: Faker::Internet.password(10, 20),
	  		confirmed_at: Faker::Time.between(DateTime.now - 365, DateTime.now-1),
	  		address: Faker::Address.city + Faker::Address.street_name + Faker::Address.secondary_address,
	  		is_chef: [true, false].sample,
  		)
  	}

  	# create chef
    puts('create chef')

  	User.where(:is_chef=>true).each do |user|
  		Chef.create(
  			user_id: user.id,
	  		first_name: Faker::Name.name,
	  		last_name: Faker::Name.name,
	  		phone_number: user.phone_number,
	  		birthday: Faker::Date.between(2.days.ago, Date.today),
	  		SSN: Faker::Number.number(10),
	  		routing_number: Faker::Number.number(10),
	  		account_number: Faker::Number.number(10),
  		)
  	end

  	# create restaurants
    puts('create restaurants')

    Chef.all.each do |chef|
    	Restaurant.create(
    		chef_id: chef.id,
    		name: Faker::Name.name,
    		address: Faker::Address.city + Faker::Address.street_name + Faker::Address.secondary_address,
    		latitude: Faker::Address.latitude,
    		longitude: Faker::Address.longitude,
    		phone_number: Faker::PhoneNumber.cell_phone,
    		description: Faker::Lorem.paragraph,
    		is_approved: [true, false].sample,
    		city: Faker::Address.city,
    		state: Faker::Address.state,
    		ZIP: Faker::Address.zip,
    		tax_ID: Faker::Number.number(10),
    		communication_method: ["email", "text-message"].sample,
    	)
		end

		# create foods
    puts('create foods')

		300.times {
			Food.create(
				restaurant_id: Restaurant.all.ids.sample,
				name: Faker::Pokemon.name,
				price: Faker::Commerce.price,
				is_public: [true, false].sample,
        unit: Faker::Number.between(1, 100),
        unit_name: ["quart", "kg", "piece", "package"].sample,
        max_order: Faker::Number.between(1, 100),
        availability_date: Faker::Time.between(DateTime.now - 100, DateTime.now+30),
        about: Faker::Lorem.paragraph,
        ingredients: Faker::Lorem.paragraph,
			)
		}

    # create food_comments
    puts('create food_comments')

    1000.times {
      comment = FoodComment.create(
        user_id: User.where.not(:is_chef => true).ids.sample,
        food_id: Food.all.ids.sample,
        comment: Faker::Lorem.paragraph,
        score: rand(0..5),
        is_public: [true, false].sample,
      )
      restaurant = comment.food.restaurant
      restaurant.food_comments_count += 1
      restaurant.food_avg_score = restaurant.get_food_avg_score
      restaurant.save!
    }

		# create orders
    puts('create orders')

		200.times {
			Order.create(
				scheduled_time: Faker::Time.between(DateTime.now , DateTime.now+30),
				user_id: User.all.ids.sample,
				restaurant_id: Restaurant.all.ids.sample,
				customer_name: Faker::Name.name,
				shipping_method: ["bulk_buy", "delivery"].sample,
				shipping_place: Faker::Address.city + Faker::Address.street_name,
				amount: Faker::Commerce.price,
				payment_method: ["paypal", "credit_card"].sample,
				payment_status: ["Unpaid", "paid"].sample,
				order_status: ["completed","not yet","cancel"].sample,
        created_at: Faker::Time.between(DateTime.now-720 , DateTime.now),
			)
		}

		# create order_food_ships
    puts('create order_food_ships')

		1000.times {
			order = OrderFoodShip.create(
				order_id: Order.all.ids.sample,
				food_id: Food.all.ids.sample,
				quantity: Faker::Number.between(1, 10),
			)

			quantity = order.quantity
			price = Food.find(order.food_id).price

			order.amount = quantity * price
			order.save!
    }

    # create restaurant_cuisine_ships
		puts('create restaurant_cuisine_ships')

    Restaurant.all.each do |restaurant|
      3.times{
        restaurant.restaurant_cuisine_ships.create(:cuisine_id => Cuisine.all.sample.id)
      }
    end

    # create big_buns
    puts('create big_buns')

    Restaurant.all.each do |restaurant|
      4.times{
        user_id = [User.all.sample.id,nil,1,2,3].sample
        start_datetime = Time.now - rand(0..30).days
        stop_datetime = start_datetime + rand(5..30).days

        big_bun1 = restaurant.big_buns.create(
          :user_id => user_id,
          :start_datetime => start_datetime,
          :stop_datetime => stop_datetime,
          :style => Faker::Name.name,
          :unit => rand(1..5),
          :prepare_time => "01:00:00",
          :usage => "self"
        )

        big_bun2 = big_bun1.dup
        big_bun2.usage = 'gift'
        big_bun2.save!
      }
    end
	end

  task :count_order_amount => :environment do

    Order.all.each do |order|
      sum = order.order_food_ships.sum(:amount)
      order.amount = sum
      order.save!
    end
  end

end