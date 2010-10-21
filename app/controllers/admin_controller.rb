class AdminController < ApplicationController
  #Code here
  before_filter :authenticate_admin!
  def index
    
  end
  def new
    
  end
  def update_signups
    #do nothing for now
    flash[:notice] = "signups opened"
    redirect_to(admin_root_path)
  end
end