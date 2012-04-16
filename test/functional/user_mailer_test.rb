require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
# Load Test Data
fixtures :users

  def setup
    @user = users(:alice)
    @user.generate_token(:password_reset_token)
  end
  
  test "password_reset" do
    mail = UserMailer.password_reset(@user)
    assert_equal "find-fix.com - Password Reset", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["noreply@find-fix.com"], mail.from
  end

end
