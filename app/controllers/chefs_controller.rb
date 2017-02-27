class ChefsController < ApplicationController

  before_action :find_chef_restaurant, :only =>[
    :show, :edit, :update, :review, :approve, :add_dish,
    :save_dish, :menu, :sales, :yep_or_not, :business, :summary,:advance,:delivering,
    :completed,:cancelled]

  before_action :find_user, :only =>[
    :show, :edit, :update, :review, :approve, :add_dish,
    :save_dish, :menu, :sales, :yep_or_not, :business, :summary,:advance,:delivering,
    :completed,:cancelled]

  # before_action :is_current_user?, :except => [:new]
  # before_action :has_authority?, :except => [:new]
  before_action :user_admin?, :only => [:approve, :review]
  before_action :find_orders, :only => [:sales,:summary, :delivering, :advance,:completed,:cancelled]

  def new
    @user = User.new
    @chef = Chef.new
  end

  def create
    create_pass = true
    flash[:alert] = []

    @chef = Chef.new(chef_params)

    # check email
    if User.find_by(:email => user_params[:email])
      create_pass = false
      flash[:alert] << "user exist!"
    else
      # create user
      @user = User.new(user_params)
      @user.name = chef_params[:first_name]
      @user.foodie_id = chef_params[:first_name]
      @user.phone_number = chef_params[:phone_number]
      @user.is_chef = true

      if !params[:chef][:user_attributes][:password].blank?
        @user.password = params[:chef][:user_attributes][:password]
      else
        flash[:alert] << "password fail"
      end

      # save user pass
      if @user.save
        @chef.user = @user

        # save chef & restaurant & delivery & bulk_buys
        if @chef.save

          bulk_buy_time_to_utc

          if !bulk_buy_checked
            @chef.restaurant.bulk_buys.destroy_all
          end

          if !delivery_checked && @chef.restaurant.delivery
            @chef.restaurant.delivery.destroy_all
          end

        else
          @user.destroy
          create_pass = false
          flash[:alert] << "save chef fail"
        end

        # save user fail
      else
        create_pass = false
        flash[:alert] << "save user fail"
      end
    end

    if create_pass
      flash[:notice] = "Chef create done, please confirm by email."
      redirect_to main_index_path
    else

      @user = User.new
      @chef = Chef.new(chef_params)
      flash[:alert] << "Register chef fail"
      redirect_to new_chef_path
    end

  end

  # show
  def sales
    today_orders = @paid_process_orders.where(order_status: "process").where(:pick_up_time => @today_time_range)
    @orders = today_orders.where( ["pick_up_time > ?", @datetime_now_to_utc] )
  end

  def summary
    # Today's ORDERS
    today_orders = @paid_process_orders.where(order_status: "process").where(:pick_up_time => @today_time_range)
    @orders = today_orders.where(["pick_up_time > ?",@datetime_now_to_utc])
    render_js
  end

  def advance
    not_today_orders = @paid_process_orders.where(order_status: "process").where.not(:pick_up_time => @today_time_range)
    advance_orders = not_today_orders.where(["pick_up_time > ?",@datetime_now_to_utc])
    @orders = advance_orders
    render_js
  end

  def delivering
    @orders = @paid_process_orders.where(order_status: "process").where(["pick_up_time < ?",@datetime_now_to_utc])
    render_js
  end

  def completed
    @orders = @paid_process_orders.where(:order_status => 'completed')
    render_js
  end

  def cancelled
    @orders = @paid_process_orders.where(:order_status => 'cancelled')
    render_js
  end

  def business
  end

  def edit
  end

  def update
    if !params[:chef][:user_attributes][:password].blank?
      @chef.user.password = params[:chef][:user_attributes][:password]
      @chef.user.save!
    end

    if @chef.update!(chef_params)
      # 處理bulk_buy 時間 to utc
      bulk_buy_time_to_utc

      redirect_to sales_chef_path(@chef)
    else
      flash[:alert] = "update fail"
      render :action => :edit
    end
  end

  def review
  end

  def approve
    @restaurant = @chef.restaurant
    if @restaurant.update(:is_approved => true)
      redirect_to sales_chef_path(@chef)
    else
      flash[:alert] = "approve fail"
      render :action => :review
    end
  end

  def menu
    @foods = @chef.restaurant.foods.all
    @big_buns = @chef.restaurant.big_buns.all
  end


  def yep_or_not
    submit = params[:commit]
    confirmation_number = params[:confirmation_number]
    order = Order.find(params[:order_id])

    if submit == "Yep!"
      if confirmation_number.present?
        if confirmation_number == order.confirmation_number
          order.order_status = "completed"
          order.save!
          flash[:notice] = "Successfully completed order"
        else
          flash[:alert] = "Confirmation number is wrong!"
        end
      else
        flash[:alert] = "Please input confirmation number"
      end

    else
      # 勾選原因, 評價完使用者後
      raise
      order.order_status = "cancelled"
      order.save!
      flash[:notice] = "Successfully cancel order"
    end
    redirect_to sales_chef_path(@chef)
  end

  private

  def render_js
    respond_to do |format|
      format.js {render 'sales'}
    end
  end


  def chef_params
    params.require(:chef).permit(
      :first_name, :last_name, :phone_number, :birthday,
      :SSN, :routing_number, :account_number,

      :restaurant_attributes => [
        :id, :name, :address, :phone_number,:description,
        :city, :state, :ZIP, :tax_ID, :communication_method,
        :certificated_img, :certificated_num, :main_photo, :tax,
        :order_reach,

        :delivery_attributes => [
          :id, :min_order, :area, :distance, :completion_time,
        ],

        :bulk_buys_attributes => [
          :id, :cut_off_time, :location_1, :pick_up_time_1, :location_2, :pick_up_time_2
        ],

        :restaurant_cuisine_ships_attributes => [
          :id, :restaurant_id, :cuisine_id,
        ],

        :restaurant_dish_photos_attributes => [
          :id, :restaurant_id, :photo, :comment,
        ],
      ],

      :user_attributes => [
        :id, :email,

        :user_photo_attributes => [
          :id, :user_id, :photo,
        ],
      ],
    )
  end

  def user_params
    chef_params[:user_attributes]
  end

  def restaurant_params
    chef_params[:restaurant_attributes]
  end

  def delivery_params
    restaurant_params[:delivery_attributes]
  end

  def delivery_checked
    params[:delivery_only]
  end

  def bulk_buy_checked
    params[:bulk_buy_only]
  end

  def find_chef_restaurant
    @chef = Chef.find(params[:id])
    @restaurant = @chef.restaurant
  end

  def find_user
    @user = @chef.user
  end

  def is_current_user?
    if current_user && @user == current_user
      true
    else
      flash[:alert] = "Please Login"
      redirect_to root_path
    end
  end

  def has_authority?
    if current_user && (current_user.is_chef || current_user.is_admin)
      true
    else
      flash[:alert] = "No authority!"
      redirect_to root_path
    end
  end

  def find_orders
    @paid_process_orders = @restaurant.orders.where(:payment_status => "paid")
    # UTC time
    datetime_now = Time.now
    @datetime_now_to_utc = datetime_now.utc

    # 要確認時區的開始時間
    # TODO:加入request 的time_zone
    local_datetime_beginning = Time.now.utc.localtime.beginning_of_day
    local_datetime_end = Time.now.utc.localtime.end_of_day

    @local_datetime_beginning_to_utc = local_datetime_beginning.utc
    @local_datetime_end_to_utc = local_datetime_end.utc
    @today_time_range = (@local_datetime_beginning_to_utc..@local_datetime_end_to_utc)
  end

  def bulk_buy_time_to_utc
    chef_params[:restaurant_attributes][:bulk_buys_attributes].keys.each do |key|
      b_buy = chef_params[:restaurant_attributes][:bulk_buys_attributes][key]


      bulk_buy_id = @chef.restaurant.bulk_buy_ids[key.to_i]

      if bulk_buy_id.nil?
        # 如果拿不到id 就不要往下做了
        return
      end

      cut_off_time = nil
      pick_up_time_1 = nil
      pick_up_time_2 = nil

      cut_off_time = b_buy[:cut_off_time].to_time.utc if b_buy[:cut_off_time].present?
      cut_off_time_local = b_buy[:cut_off_time] if b_buy[:cut_off_time].present?
      pick_up_time_1 = b_buy[:pick_up_time_1].to_time.utc if b_buy[:pick_up_time_1].present?
      pick_up_time_2 = b_buy[:pick_up_time_2].to_time.utc if b_buy[:pick_up_time_2].present?

      bulk_buy = BulkBuy.find(bulk_buy_id).update(:cut_off_time => cut_off_time,
                                                  :cut_off_time_local => cut_off_time_local,
                                                  :pick_up_time_1 => pick_up_time_1,
                                                  :pick_up_time_2 => pick_up_time_2
                                                    )

    end
  end

end
