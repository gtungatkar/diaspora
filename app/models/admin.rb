class Admin
  #Code here
  include MongoMapper::Document
  plugin MongoMapper::Devise
  include Encryptor::Private
  QUEUE = MessageHandler.new
  
  devise :database_authenticatable,
         :recoverable, :trackable, :validatable, :invitable

  attr_accessible :email, :password, :password_confirmation
  
  key :username
  key :password
  key :password_confirmation
  key :serialized_private_key, String
  key :invites, Integer
  key :invitation_token, String
  key :invitation_sent_at, DateTime
  key :inviter_ids, Array
  
  key :invite_messages, Hash
  many :inviters, :in => :inviter_ids, :class_name => 'Admin'
  one :person, :class_name => 'Person', :foreign_key => :owner_id
  many :pending_requests, :in => :pending_request_ids, :class_name => 'Request'

  validates_presence_of :username
  validates_uniqueness_of :username, :case_sensitive => false
    
  
 def self.find_for_authentication(conditions={})
    if conditions[:username] =~ /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i # email regex
      conditions[:email] = conditions.delete(:username)
    end
    super
 end
######## Making things work ########
  key :email, String

  def method_missing(method, *args)
    self.person.send(method, *args)
  end

  def real_name
    #"#{person.profile.first_name.to_s} #{person.profile.last_name.to_s}"
    self.username
  end

###Invitations############
  def invite_admin(opts = {})
    u = User.find_by_email(opts[:email])
    if u.nil?
      invitable = User.new#(:email => opts[:email])
      invitable.email = opts[:email]
      invitable.invite_messages[:admin] = opts[:invite_message]
      #invitable.inviters << self
      invitable.invite!
    else
      raise "User already present"
    end
  end
          


end