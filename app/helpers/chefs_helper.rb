module ChefsHelper
	def setup_chef(chef)
	  chef.build_restaurant unless chef.restaurant
	  chef
	end
end
