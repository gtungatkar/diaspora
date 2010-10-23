class AdminSettings
  include MongoMapper::Document
  #Code here

  #is registration open?
  key :registration_open, Boolean, :default => false

  #scope for optimization
  #load the value from database once
  #cattr_accessor :reg_status
  #@@reg_status =

  def self.reg_open?
    a = AdminSettings.first()
    if a != nil
      if a.registration_open == true
          return true
        end
    end
    return false

  end

  def self.open_registration
    a = AdminSettings.first()
    if a != nil
      a.registration_open = true
      a.save
      return true
    end
    return false
  end

  def self.close_registration
    a = AdminSettings.first()
    if a != nil
      a.registration_open = false
      a.save
      return true
    end
    return false
  end
end
