class RepliesController < ApplicationController
	before_action :find_chef
  before_action :find_food_comment
  before_action :find_food_comment_reply, :only => [:update]
  before_action :is_current_user?

  def create
  	@food_comment_reply = @food_comment.food_comment_replies.new(food_comment_reply_params)
  	@food_comment_reply.chef = @chef
  	@food_comment_reply.save!

  	respond_to do |format|
      format.js
    end
  end

  def update
  	@food_comment_reply.update!(food_comment_reply_params)

  	respond_to do |format|
      format.js
    end
  end

  private

  def food_comment_reply_params
    params.require(:food_comment_reply).permit(
       :food_comment, :chef_id, :content,
    )
  end

  def find_food_comment
  	@food_comment = FoodComment.find(params[:food_comment_id])
  end

  def find_food_comment_reply
  	@food_comment_reply = FoodCommentReply.find(params[:id])
  end

  def find_chef
  	@chef = Chef.find(params[:chef_id])
  end

  def is_current_user?
		if current_user && @chef.user == current_user
			true
		else
			flash[:alert] = "Please Login"
			redirect_to :back
		end
	end
end
