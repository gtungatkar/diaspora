class AdminController < ApplicationController
  #Code here
  def index
    
  end

  def update_signups
    #do nothing for now
    flash[:notice] = "signups opened"
    redirect_to(admin_root_path)
  end
end