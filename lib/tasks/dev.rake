namespace :dev do

  desc "Rebuild system"
  task :rebuild => ["db:drop", "db:setup", :fake, :count_order_amount]


  task :fake_user => :environment do
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
  end


  task :fake => :environment do

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
    	restaurant = Restaurant.create(
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
        tax: rand(1..5),
        order_reach: rand(50..1000),
    		communication_method: ["email", "text-message"].sample,
    	)

      if [true,false].sample
        Delivery.create(
          restaurant_id: restaurant.id,
          min_order: rand(5..15),
          area: Faker::Address.city,
          distance: Faker::Number.number(3),
          cost: rand(5..10),
          order_hours: rand(1..5),

        )
      end

      rand(1..2).times {
        BulkBuy.create(
          restaurant_id: restaurant.id,
          min_order: rand(5..15),
          cut_off_time: Faker::Time.forward(0),
          location: Faker::Address.city + Faker::Address.street_name + Faker::Address.secondary_address,
          pick_up_time: Faker::Time.forward(0),
        )
      }

		end

		# create foods
    puts('create foods')

		300.times {
			Food.create(
				restaurant_id: Restaurant.all.ids.sample,
				name: Faker::Pokemon.name,
				price: Faker::Commerce.price/10,
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
			order = Order.create(
				user_id: User.all.ids.sample,
				restaurant_id: Restaurant.all.ids.sample,
				customer_name: Faker::Name.name,
				shipping_method: ["bulk_buy", "delivery"].sample,
				shipping_place: Faker::Address.city + Faker::Address.street_name,
				amount: Faker::Commerce.price,
        tip: rand(1..5),
				payment_method: ["paypal", "credit_card"].sample,
				payment_status: ["unpaid", "paid"].sample,
				order_status: ["completed","process","cancelled"].sample,
        delivery_fee: 0,
        created_at: Faker::Time.between(DateTime.now-720 , DateTime.now),
			)

      if order.shipping_method == "delivery"
        if order.restaurant.delivery
          order.delivery_fee = order.restaurant.delivery.cost
        else
          order.delivery_fee = 0
        end
      else #bulk_buy
        bulk_buy_id = order.restaurant.bulk_buys.ids.sample
        order.bulk_buy_id = bulk_buy_id
        order.pick_up_time = BulkBuy.find(bulk_buy_id).pick_up_time
      end
      order.save!
		}

		# create order_food_ships
    puts('create order_food_ships')

		1000.times {
			order = OrderFoodShip.create(
				order_id: Order.all.ids.sample,
				food_id: Food.all.ids.sample,
				quantity: Faker::Number.between(1, 5),
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
        start_datetime = Time.now - rand(0..30).days
        stop_datetime = start_datetime + rand(5..30).days

        restaurant.big_buns.create(
          :start_datetime => start_datetime,
          :stop_datetime => stop_datetime,
          :style => Faker::Name.name,
          :unit => rand(1..5),
          :prepare_time => "01:00:00",
          :is_public => [true,false].sample,
        )
      }
    end

    # create user_big_bun_ships
    puts('create user_big_bun_ships')

    BigBun.where(:is_public => true).each do |big_bun|
      ship1 = big_bun.user_big_bun_ships.create(
        user_id: User.all.where(:is_chef => false).ids.sample,
        usage: "self",
        is_used: false,
      )

      big_bun.user_big_bun_ships.create(
        user_id: ship1.user_id,
        usage: "gift",
        is_used: false,
      )
    end

	end

  task :count_order_amount => :environment do
    Order.all.each do |order|
      sum = order.order_food_ships.sum(:amount)
      order.subtotal = sum
      order.amount = order.restaurant.tax + order.tip + sum + order.delivery_fee
      order.save!
    end
  end

end