# encoding: utf-8

namespace :production do
  desc "cron job excute" #此處可自行輸入task的描述

  task :cehck_order_reach => :environment do
    puts "cron job excute"
    puts(Time.now().localtime)

    hour_now = Time.now.utc.hour.to_s
    cut_off_time = "2000-01-01 " + hour_now + ":00:00"
    # 先找出這個時間需要看的
    bulk_buys = BulkBuy.where(:cut_off_time => cut_off_time)
    puts "bulk_buys.ids"
    puts(bulk_buys.ids)
    bulk_buys.each do |bulk_buy|
      restaurant = bulk_buy.restaurant
      restaurant.check_order_reach(bulk_buy.id)
    end

  end
end

namespace :dev do

  desc "Rebuild system"
  task :rebuild => ["db:drop", "db:setup",:fake, :count_order_amount]

  task :fake => :environment do

    # admin@admin.com
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

    # chef@chef.com
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

    # me
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

    # create 50 users
    puts('create 50 users')

    0.times {
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
        address: "New York City " + Faker::Address.street_name + Faker::Address.secondary_address,
        latitude: 40.730610 + rand(-0.3..0.3),
        longitude: -73.935242 + rand(-0.3..0.3),
        phone_number: Faker::PhoneNumber.cell_phone,
        description: Faker::Lorem.paragraph,
        is_approved: [true, false].sample,
        city: "New York City",
        state: "NY",
        ZIP: Faker::Address.zip,
        tax_ID: Faker::Number.number(10),
        tax: rand(1..5),
        order_reach: rand(50..1000),
        communication_method: ["email", "text-message"].sample,
      )

      if [true,false].sample
        delivery = Delivery.create(
          restaurant_id: restaurant.id,
          min_order: rand(5..15),
          area: Faker::Address.city,
          distance: Faker::Number.number(3),
          cost: rand(5..10),
          completion_time: rand(1..5),

        )
      end

      rand(1..2).times {
        bulk_buy = BulkBuy.create(
          restaurant_id: restaurant.id,
          min_order: rand(5..15),
          cut_off_time: "#{rand(0..12)}:00:00".to_time,
          cut_off_time_local: "#{rand(0..12)}:00:00".to_time,
          pick_up_time_1: "#{rand(0..12)}:00:00".to_time,
          location_1: Faker::Address.city + Faker::Address.street_name + Faker::Address.secondary_address,
          pick_up_time_2: "#{rand(13..23)}:00:00".to_time,
        )

        if bulk_buy.pick_up_time_2.present?
          bulk_buy.location_2 = Faker::Address.city + Faker::Address.street_name + Faker::Address.secondary_address
          bulk_buy.save!
        end
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
        support_lunch: [true, false].sample,
        support_dinner: [true, false].sample,
        support_days: [[1,3,5,0],[2,4,6],[1,2,3,4,5],[1,2,3,4,5,6,0],[6,0]].sample
      )
    }

    # create food_comments
    puts('create food_comments')

    500.times {
      restaurant_id = Restaurant.ids.sample
      food_id = Restaurant.find(restaurant_id).foods.ids.sample

      comment = FoodComment.create(
        user_id: User.where.not(:is_chef => true).ids.sample,
        food_id: food_id,
        restaurant_id: restaurant_id,
        comment: Faker::Lorem.paragraph,
        taste_score: rand(1..5),
        value_score: rand(1..5),
        on_time_score: rand(1..5),
        is_public: true,
      )

      comment.summary_score = comment.get_summary_score
      comment.save!

      restaurant = Restaurant.find(restaurant_id)
      restaurant.food_comments_count += 1
      restaurant.update_score
      restaurant.save!
    }

    # create food_comment_replies
    puts('create food_comment_replies')

    FoodComment.all.each do |comment|
      is_reply = [true,false].sample
      if is_reply
        reply = FoodCommentReply.create(
          chef_id: comment.restaurant.chef.id,
          food_comment_id: comment.id,
          content: Faker::Lorem.paragraph,
        )
        reply.save!
      end
    end

    # create orders
    puts('create orders')

    100.times {
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
      else #bulk_buy
        bulk_buy_id = order.restaurant.bulk_buys.where.not(:pick_up_time_1 => nil).ids.sample
        order.bulk_buy_id = bulk_buy_id
        order.pick_up_time = BulkBuy.find(bulk_buy_id).pick_up_time_1
      end
      order.save!
    }

    # create order_food_ships
    puts('create order_food_ships')

    500.times {
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
      order.amount = order.restaurant.tax + order.tip + sum
      order.save!
    end
  end

end