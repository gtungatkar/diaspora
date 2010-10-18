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
end