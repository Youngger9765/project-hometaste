class UserMailer < ApplicationMailer

	default :from => "Homeaste <homeaste@homeaste.com>"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.user_not_yet_order.subject
  #
  def user_not_yet_order(user, reason)
    @user = user
    @reason = reason
    mail(:to => user.email, :subject => "[Homeaste] Refound Notify")
  end

  def send_orders_reached_to_chef(chef)
    @chef = chef
    mail(:to => chef.user.email, :subject => "[Homeaste] Orders Build Notify")
  end
end
