# each user can use different socialnetwork for same account
Spree::User.class_eval do
  has_many :oauth_accounts

  #https://github.com/plataformatec/devise/wiki/OmniAuth%3A-Overview
  def self.from_omniauth(auth)
    return nil unless auth.present?
    find_by_auth( auth ) || create_by_auth( auth )
  end


  # search user by provider and data
  # in migration exist index
  def self.find_by_auth( auth )
    self.joins(:oauth_accounts).where(:spree_oauth_accounts => {:provider => auth['provider'],:uid => auth['uid'] }).limit(1).first
  end

  #
  def self.create_by_auth( auth )

    user = self.new
    user.login = auth['user_info']['nickname']
    user.password = Devise.friendly_token[0,20]

    user.build_oauth_account(
                        :provider => auth['provider'],
                        :uid => auth['uid'],
                        :user_info => auth['user_info'],
                        :name => auth['user_info']['name']
                       )
    user.save ? user : nil

  end
end
