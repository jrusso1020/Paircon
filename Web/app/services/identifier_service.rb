class IdentifierService
  def initialize auth, user=nil
    @auth = Hashie::Mash.new auth
    @user = user
  end

  def resolve
    user = nil

    User.transaction do
      identity = find_or_create_identity
      user     = ensure_user identity
      link identity, user
    end

    user
  end

  private

  def find_or_create_identity
    Identity.where(provider: @auth.provider, uid: @auth.uid).
        create_with(auth_data: @auth).first_or_create!
  end

  def ensure_user identity
    @user ||= identity.user
    return @user if @user

    @user = User.where(email: identity.email).
        create_with(
            first_name:     identity.first_name,
            last_name:      identity.last_name,
            password:  Devise.friendly_token[0,20]
        ).first_or_create!

    if @auth.provider =~ /facebook/i
      @user.logo = URI.parse(identity.image.gsub("http","https") + "?width=200&height=200")
    else
      @user.logo = URI.parse(identity.image.gsub("https","http").gsub(/sz=50/i,'sz=200'))
    end
    @user.save!(validate: false)

    @user
  end

  def link identity, user
    identity.update_attribute :user, user unless identity.user == user
  end
end