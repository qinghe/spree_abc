class MailPreview < MailView
  def load_sample()
    site = Spree::Site.create!(:name=>"ABC",:domain=>"www.example.com")
    user = site.users.create!(:email=>'abc@example.com',:password=>"spree123",:password_confirmation=>"spree123")
    mail = Spree::UserMailer.load_sample(user)
    site.destroy
    mail
  end
end
