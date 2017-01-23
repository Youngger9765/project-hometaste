# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/user_not_yet_order
  def user_not_yet_order
    UserMailer.user_not_yet_order
  end

end
