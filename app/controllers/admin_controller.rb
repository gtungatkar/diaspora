class AdminController < ApplicationController
  #Code here
  before_filter  :authenticate_admin!

  def index
    
  end
  def new
    
  end
  def update_signups
    #do nothing for now
   # if AdminSettings.reg_open?
      if params[:reg] == "close"
        AdminSettings.close_registration()
        flash[:notice] = "signups are closed"
      else
        AdminSettings.open_registration()
        flash[:notice] = "signups are opened now"
      end
    redirect_to(admin_root_path)
    end
  #end
  
end
