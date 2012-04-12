class UserMailer < ActionMailer::Base
  default :from => "noreply@find-fix.com"
  
  def password_reset(user)
    @user = user

    mail :to => user.email, :subject => "find-fix.com - Password Reset"
  end
end
