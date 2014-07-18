class User < ActiveRecord::Base
  # not all database adapters use case sensitive indexes, 
  # so downcase the email in the before_save callback
  #before_save { self.email = email.downcase }
  before_save { email.downcase! }
  
  # include password hashing and authentication features
  has_secure_password
  
  
  # validators
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates( :name, { presence: true, length: { maximum: 50 } } )
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  
  
end
