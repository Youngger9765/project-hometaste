class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  validates :name, presence: true
  validates :user_name, presence: true
  validates :phone_number, presence: true

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
    user.user_name = user.fb_name
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

  def is_admin?
      self.is_admin
  end
end
