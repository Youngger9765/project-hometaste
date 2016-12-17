module ChefsHelper
	def setup_chef(chef)
	  chef.build_restaurant unless chef.restaurant
	  chef.build_user unless chef.user
	  chef.build_restaurant.build_delivery unless chef.restaurant.delivery
	  chef
	end
end
