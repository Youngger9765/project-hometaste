class Admin::MainController < ApplicationController

	layout "admin"
	# before_action :authenticate_user!
  before_action :user_admin?

	def index
		@last_year = Order.order("created_at").last.created_at.year
		@first_year = Order.order("created_at").first.created_at.year
		@order_filter = Order.new
		@orders = Order.all

		if params[:order]
			# filter by year
			if params[:order][:year_filter] != "select year"

				# specific year
				if params[:order][:year_filter] != "all"
					select_year = params[:order][:year_filter].to_i
					@orders = Order.where('extract(year  from created_at) = ?', select_year)

					# filter by specific month
					if params[:order][:month_filter] != "select month"
							select_month = params[:order][:month_filter].to_i
							@orders = @orders.where('extract(month  from created_at) = ?', select_month)
					end

				end
			end
		end
	end

	def destroy
		
	end

	private

end
