class CommentsController < ApplicationController
  before_action :find_restaurant
  before_action :find_food_comments

  def index
    @comment = FoodComment.new
    @foods = @restaurant.foods

    @food_comments = @food_comments.page(params[:page]).per(5)
    if @food_comments.last_page?
      @next_page = nil
    else
      @next_page = @food_comments.next_page
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create_food_comment
    # 可以用這個指標判斷是否成功建立
    @create_pass = false

    unless current_user
      @message = 'Need to login first'
    else
      food_comment = FoodComment.new(food_comment_params)
      food_comment.user = current_user
      food_comment.restaurant = @restaurant
      food_comment.summary_score = food_comment.get_summary_score

      if food_comment.save!
        @create_pass = true

        # 更新餐廳資訊
        @restaurant.update_score
        @restaurant.food_comments_count += 1
        @restaurant.save!
      end
    end

    @food_comments_count = @restaurant.food_comments_count
    @food_comments = @food_comments.first(5)

    respond_to do |format|
      format.js
    end
  end

  def update_food_comment
    @food_comment = FoodComment.find(params[:id])

    if @food_comment.nil?
      @message = "please refresh page"
    elsif !current_user
      @message = 'Need to login first'
    elsif current_user != @food_comment.user
      @message = "You are not allow to do this!"
    else
      @food_comment.update!(food_comment_params)
      restaurant = @food_comment.restaurant

      if @food_comment.save!
        # 更新summary_score
        @food_comment.summary_score = @food_comment.get_summary_score
        @food_comment.save!

        # 餐廳重新寄分
        restaurant.update_score
        restaurant.save!
      end
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def find_food_comments
    @food_comments = @restaurant.food_comments.includes(:user, :food).order('updated_at desc')
  end

  def food_comment_params
    params.require(:food_comment).permit(
        :food_id, :restaurant_id, :user_id,
        :taste_score, :value_score, :on_time_score,
        :comment
    )
  end

end
