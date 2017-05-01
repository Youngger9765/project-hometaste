class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  validates :email, presence: true , uniqueness: true
  validates :name, presence: true
  validates :foodie_id, presence: true
  validates :phone_number, presence: true

  has_one :chef
  has_one :user_photo

  has_many :orders
  has_many :carts
  has_many :food_comments
  has_many :user_big_bun_ships
  has_many :big_buns, :through => :user_big_bun_ships

  has_many :user_food_likings
  has_many :liking_foods , :source => :food, :through => :user_food_likings

  has_many :user_restaurant_likings
  has_many :liking_restaurants , :source => :restaurant, :through => :user_restaurant_likings


  has_many :messages
  has_many :conversations, foreign_key: :sender_id
  has_many :recieved_conversations, foreign_key: :recipient_id, class_name: Conversation

  accepts_nested_attributes_for :user_photo,
                                allow_destroy: true,
                                reject_if: :all_blank

  serialize :prefered_cuisine_ids


  def self.from_omniauth(auth)
    # Case 1: Find existing user by facebook uid
    user = User.find_by_fb_uid( auth.uid )
    if user
      user.fb_name = auth[:info][:name]
      user.fb_email = auth[:info][:email]

      if auth[:info][:image].include?"graph.facebook"
        user.fb_head_shot = auth[:info][:image]
      else
        user.fb_head_shot = "https://graph.facebook.com/" + auth.uid + "/picture?type=large"
      end

      # if user.head_shot_file_name.nil? && auth.info.image.present?
      #   if auth[:info][:image].include?"graph.facebook"
      #     auth_image = auth[:info][:image]
      #   else
      #     auth_image = "https://graph.facebook.com/" + auth.uid + "/picture?type=large"
      #   end
      #   image_url = user.process_uri(auth_image)
      #   user.head_shot = URI.parse(image_url)
      # end

      user.fb_token = auth.credentials.token
      user.fb_raw_data = auth
      user.skip_confirmation!
      user.save!
      return user
    end

    # Case 2: Find existing user by email
    existing_user = User.find_by_email( auth.info.email )
    if existing_user

      if existing_user.is_chef
        return
      end

      if !existing_user.foodie_id
        existing_user.foodie_id = auth[:info][:name]
      end

      # if existing_user.head_shot_file_name.nil? && auth.info.image.present?

      #   if auth[:info][:image].include?"graph.facebook"
      #     auth_image = auth[:info][:image]
      #   else
      #     auth_image = "https://graph.facebook.com/" + auth.uid + "/picture?type=large"
      #   end

      #   image_url = existing_user.process_uri(auth_image)
      #   existing_user.head_shot = URI.parse(image_url)
      # end

      existing_user.fb_name = auth[:info][:name]
      existing_user.fb_email = auth[:info][:email]
      existing_user.fb_uid = auth.uid

      if auth[:info][:image].include?"graph.facebook"
        existing_user.fb_head_shot = auth[:info][:image]
      else
        existing_user.fb_head_shot = "https://graph.facebook.com/" + auth.uid + "/picture?type=large"
      end

      existing_user.fb_token = auth.credentials.token
      existing_user.fb_raw_data = auth
      existing_user.skip_confirmation!
      existing_user.save!
      return existing_user
    end

    # Case 3: Create new password
    user = User.new
    user.name = auth.info.name
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]

    # if auth.info.image.present?
    #   if auth[:info][:image].include?"graph.facebook"
    #     auth_image = auth[:info][:image]
    #   else
    #     auth_image = "https://graph.facebook.com/" + auth.uid + "/picture?type=large"
    #   end
    #   image_url = user.process_uri(auth_image)
    #   user.head_shot = URI.parse(image_url)
    # end

    # fb info
    user.fb_uid = auth.uid
    user.fb_token = auth.credentials.token
    user.fb_raw_data = auth
    user.fb_name = auth[:info][:name]
    user.fb_email = auth[:info][:email]

    user.name = user.fb_name
    user.foodie_id = user.fb_name
    user.phone_number = "0"

    if auth[:info][:image].include?"graph.facebook"
      user.fb_head_shot = auth[:info][:image]
    else
      user.fb_head_shot = "https://graph.facebook.com/" + auth.uid + "/picture?type=large"
    end

    user.skip_confirmation!
    user.save!
    return user
  end

  def self.find_for_google_oauth2(auth)

    # Case 1: Find existing user by google uid
    user = User.find_by_google_uid( auth.uid )
    if user

      if !user.foodie_id
        user.foodie_id = auth[:info][:name]
      end

      user.google_name = auth[:info][:name]
      user.google_email = auth[:info][:email]
      user.google_head_shot = auth[:info][:image]
      user.google_token = auth.credentials.token
      user.google_raw_data = auth
      user.google_head_shot = auth[:info][:image]

      user.skip_confirmation!
      user.save!
      return user
    end


    # Case 2: Find existing user by email
    existing_user = User.find_by_email( auth.info.email )
    if existing_user

      if existing_user.is_chef
        return
      end

      if !existing_user.foodie_id
        existing_user.foodie_id = auth[:info][:name]
      end

      existing_user.google_name = auth[:info][:name]
      existing_user.google_email = auth[:info][:email]
      existing_user.google_uid = auth.uid
      existing_user.google_token = auth.credentials.token
      existing_user.google_raw_data = auth
      existing_user.google_head_shot = auth[:info][:image]

      existing_user.skip_confirmation!
      existing_user.save!
      return existing_user
    end

    # Case 3: Create new password
    user = User.new
    user.name = auth.info.name
    user.foodie_id = auth.info.name
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.phone_number = "0"

    # google info
    user.google_uid = auth.uid
    user.google_token = auth.credentials.token
    user.google_raw_data = auth
    user.google_name = auth[:info][:name]
    user.google_email = auth[:info][:email]
    user.google_head_shot = auth[:info][:image]

    user.skip_confirmation!
    user.save!
    return user
  end

  def is_admin?
    self.is_admin
  end

  def virtual_name

  end
end
