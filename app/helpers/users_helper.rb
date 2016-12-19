module UsersHelper
	def setup_user(user)
		user.build_user_photo unless user.user_photo
		user
	end
end
