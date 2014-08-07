class User < ActiveRecord::Base
  # not all database adapters use case sensitive indexes, 
  # so downcase the email in the before_save callback
  #before_save { self.email = email.downcase }
  before_save { email.downcase! }
  
  # use the before_create callback to verify the 
  # creation of a session token for each user
  before_create :create_remember_token
  
  
  # include password hashing and authentication features
  has_secure_password
  
  
  # validators
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates( :name, { presence: true, length: { maximum: 50 } } )
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  
  
  
  # remember_token utility methods
  # generate a random string of alpha-numeric characters
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  # hash a token using SHA1
  def User.digest( token )
    Digest::SHA1.hexdigest( token.to_s )
  end
  
  private
  
    def create_remember_token()
      self.remember_token = User.digest( User.new_remember_token )
    end
  
end
