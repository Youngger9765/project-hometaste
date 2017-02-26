class CommentsController < ApplicationController
  before_action :find_restaurant

  def index
    @comment = FoodComment.new
    @foods = @restaurant.foods
    @food_comments = @restaurant.food_comments
  end

  def create_food_comment
    # 可以用這個指標判斷是否成功建立
    @create_pass = false

    @food_comment = FoodComment.new(food_comment_params)
    @food_comment.user = current_user
    @food_comment.restaurant = @restaurant
    @food_comment.summary_score = @food_comment.get_summary_score

    if @food_comment.save!
      @create_pass = true

      # 更新餐廳資訊
      @restaurant.update_score
      @restaurant.food_comments_count += 1
      @restaurant.save!
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def food_comment_params
    params.require(:food_comment).permit(
      :food_id, :restaurant_id, :user_id,
      :taste_score, :value_score, :on_time_score,
      :comment,
    )
  end

end
