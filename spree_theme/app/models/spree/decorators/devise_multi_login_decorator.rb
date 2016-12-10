#https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
Spree::User.class_eval do
  devise :authentication_keys=> [ :login ]
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates_format_of :cellphone, with: /\A0?(13\d|14[5,7]|15[0-3,5-9]|17[0,6-8]|18\d)\d{8}\z/, allow_blank: true

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["cellphone = :value OR email = :value", { :value => login.downcase }]).first
    else
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_hash).first
    end
  end

  def login
    @login || ( login_by_email? ? self.email : self.cellphone )
  end

  def login_by_email?
    self.email.present?
  end

  def email_required?
    login_by_email?
  end
end
