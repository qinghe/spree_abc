class Spree::UserMailer < ActionMailer::Base
  default :from => "rubyecommerce@gmail.com"

  def load_sample(user)
    @user = user
    mail(:to => user.email, :subject => user.site[:name] )
  end

end
