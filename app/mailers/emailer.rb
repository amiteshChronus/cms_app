class Emailer < ActionMailer::Base
  default from: "from@example.com"

  def password_new(user)
  end

  def send_mail(prof)
  	@prof=prof
  	# @password=('0'..'z').to_a.shuffle.first(8).join
  	mail to: @prof.email, subject: "Welcome to Course Management System"
  end  

  def password_reset(user)
  	@user = user
  	mail :to => user.email, :subject => "Password Reset"
  end
end
