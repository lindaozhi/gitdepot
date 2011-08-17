class FavouritesController < ApplicationController
  # GET /favourites
  # GET /favourites.xml
  def index
    @favourites = Favourite.paginate :page => params[:page],:order => 'created_at desc',:per_page=>10,:conditions => "user_id = #{session[:user_id]}" 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @favourites }
    end
  end

  # GET /favourites/1
  # GET /favourites/1.xml
  def show
    @favourite = Favourite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @favourite }
    end
  end

  # GET /favourites/new
  # GET /favourites/new.xml
  def new
    @favourite = Favourite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @favourite }
    end
  end

  # GET /favourites/1/edit
  def edit
    @favourite = Favourite.find(params[:id])
  end

  # POST /favourites
  # POST /favourites.xml
  def create
     @temp = Favourite.count(:conditions => ["product_id = ? and user_id = ?",params[:id],session[:user_id]])
    if @temp != 0
      redirect_to favourites_url
      return
    end
    @favourite = Favourite.new
    @favourite.product_id = params[:id]
    @favourite.user_id = session[:user_id]
    @favourite.save
    redirect_to favourites_url
    # respond_to do |format|
      # if @favourite.save
        # format.html { redirect_to(@favourite, :notice => 'Favourite was successfully created.') }
        # format.xml  { render :xml => @favourite, :status => :created, :location => @favourite }
      # else
        # format.html { render :action => "new" }
        # format.xml  { render :xml => @favourite.errors, :status => :unprocessable_entity }
      # end
    # end
  end

  # PUT /favourites/1
  # PUT /favourites/1.xml
  def update
    @favourite = Favourite.find(params[:id])

    respond_to do |format|
      if @favourite.update_attributes(params[:favourite])
        format.html { redirect_to(@favourite, :notice => 'Favourite was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @favourite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /favourites/1
  # DELETE /favourites/1.xml
  def destroy
    @favourite = Favourite.find(params[:id])
    @favourite.destroy

    respond_to do |format|
      format.html { redirect_to(favourites_url) }
      format.xml  { head :ok }
    end
  end
end
