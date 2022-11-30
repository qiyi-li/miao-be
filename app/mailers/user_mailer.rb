class UserMailer < ApplicationMailer
  def welcome_email
    mail(to: 'errgou@gmail.com', subject: 'Welcome to My Awesome Site')
  end
end