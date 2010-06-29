class BookmarksController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @bookmark = Bookmark.new
    @bookmarks = Bookmark.sort(:created_at.desc).all
  end
  
  def edit
    @bookmark = Bookmark.first(:conditions => {:id => params[:id]})
  end
  
  def update
    @bookmark = Bookmark.first(:conditions => {:id => params[:id]})
    if @bookmark.update_attributes(params[:bookmark])
      flash[:notice] = "Successfully updated bookmark."
      redirect_to @bookmark
    else
      render :action => 'edit'
    end
  end
  
  def show
    @bookmark = Bookmark.first(:conditions => {:id => params[:id]})
  end
  
  def create
    @bookmark = Bookmark.new(params[:bookmark])
    @bookmark.person = current_user
    if @bookmark.save
      flash[:notice] = "Successfully created bookmark."
      redirect_to @bookmark
    else
      render :action => 'new'
    end
  end
  
  def new
    @bookmark = Bookmark.new
  end
  
  def destroy
    @bookmark = Bookmark.first(:conditions => {:id => params[:id]})    
    @bookmark.destroy
    flash[:notice] = "Successfully destroyed bookmark."
    redirect_to bookmarks_url
  end
end