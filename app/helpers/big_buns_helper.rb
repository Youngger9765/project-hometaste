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
end
