require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "user_not_yet_order" do
    mail = UserMailer.user_not_yet_order
    assert_equal "User not yet order", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
