class Admin
  #Code here
  include MongoMapper::Document
  plugin MongoMapper::Devise

  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation
  
  key :username
  key :password
  key :password_confirmation

 
 def self.find_for_authentication(conditions={})
    if conditions[:username] =~ /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i # email regex
      conditions[:email] = conditions.delete(:username)
    end
    super
  end
end