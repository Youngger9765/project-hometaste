module BigBunsHelper
	def setup_big_bun(big_bun)
		# new
		if !big_bun.id
			big_bun.build_big_bun_photo

			# edit
		else
			if !big_bun.big_bun_photo
				big_bun.build_big_bun_photo
			else
				big_bun.big_bun_photo
			end
		end

		big_bun
	end

	def bigbun_status_class( bigbun )
		if bigbun
			if bigbun.is_preparing?
				'before_prepartion'
			elsif bigbun
				'after_prepartion'
			end
		end
	end

end
