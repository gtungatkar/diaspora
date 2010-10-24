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
    #if self.invites > 0

     # aspect_id = opts.delete(:aspect_id)
     # if aspect_id == nil
     #   raise "Must invite into aspect"
     # end
     # aspect_object = self.aspects.find_by_id(aspect_id)
     # if !(aspect_object)
     #   raise "Must invite to your aspect"
     # else
       #request = Request.instantiate(
        #    :to => "http://local_request.example.com",
        #    :from => self.person        #:into => aspect_id
        #  )

        u = User.find_by_email(opts[:email])
        if u.nil?
         Rails.logger.info "Email : #{opts[:email]}"
         invitable = find_or_initialize_with_error_by(:email, opts[:email])
         #invitable = User.new#(:email => opts[:email])

         #invitable.email = #"try"
        #u = User.new.invite!(:email => opts[:email])
        Rails.logger.info "Invitable : #{invitable.email}"         
         invitable.invite!
       # elsif friends.include?(u.person)
       #   raise "You are already friends with this person"
        #elsif not u.invited?
        #  self.send_friend_request_to(u.person, aspect_object)
        #  return
        #elsif u.invited? && u.inviters.include?(self)
        #  raise "You already invited this person"
        #else
        #  flash[:notice] = "There is already a user with this email"
        end
     # end


   #   invited_user = User.invite!(:email => opts[:email], :request => request, :inviter => self, :invite_message => opts[:invite_message]) 

     # self.invites = self.invites - 1
      #self.pending_requests << request if request
      #request.save
      #self.save!
      #u
    #else
    #  raise "You have no invites"
    #end
  end
          
  def self.invite!(attributes={})
    inviter = attributes.delete(:inviter)
    request = attributes.delete(:request)

    invitable = find_or_initialize_with_error_by(:email, attributes.delete(:email))
    invitable.attributes = attributes
    if invitable.inviters.include?(inviter)
      raise "You already invited this person"
    else
      invitable.pending_requests << request if request
      invitable.inviters << inviter
      message = attributes.delete(:invite_message)
      if message
        invitable.invite_messages[inviter.id.to_s] = message
      end
    end

    if invitable.new_record?
      invitable.errors.clear if invitable.email.try(:match, Devise.email_regexp)
    else
      invitable.errors.add(:email, :taken) unless invitable.invited?
    end

    invitable.invite! if invitable.errors.empty?
    invitable
  end

  def accept_invitation!(opts = {})
    if self.invited?
      self.username              = opts[:username]
      self.password              = opts[:password]
      self.password_confirmation = opts[:password_confirmation]
      opts[:person][:diaspora_handle] = "#{opts[:username]}@#{APP_CONFIG[:terse_pod_url]}"
      opts[:person][:url] = APP_CONFIG[:pod_url]

      opts[:serialized_private_key] = User.generate_key
      self.serialized_private_key =  opts[:serialized_private_key]
      opts[:person][:serialized_public_key] = opts[:serialized_private_key].public_key

      person_hash = opts.delete(:person)
      self.person = Person.create(person_hash)
      self.person.save
      self.invitation_token = nil
      self.save
      self
    end
  end
  

end