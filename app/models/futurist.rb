class Futurist < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'futurist@thefuture'
  TEMP_EMAIL_REGEX = /\Afuturist@thefuture/
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable
         
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  
  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and futurist if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing futurist
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    futurist = signed_in_resource ? signed_in_resource : identity.futurist

    # Create the futurist if needed
    if futurist.nil?

      # Get the existing futurist by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # futurist to verify it on the next step via FuturistsController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      futurist = Futurist.where(:email => email).first if email

      # Create the futurist if it's a new registration
      if futurist.nil?
        futurist = Futurist.new(
          name: auth.extra.raw_info.name,
          #futuristname: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        futurist.skip_confirmation!
        futurist.save!
      end
    end

    # Associate the identity with the futurist if needed
    if identity.futurist != futurist
      identity.futurist = futurist
      identity.save!
    end
    futurist
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end
