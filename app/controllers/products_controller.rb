class ProductsController < ApplicationController
  skip_before_filter :authorize, :only => :show
  # GET /products
  # GET /products.xml
  def index
    @products = Product.paginate :page=>params[:page], :order=>'created_at desc',:per_page =>5
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])
    if session[:user_id] 
      @user = User.find(session[:user_id])
    end
    @comments =Comment.paginate :page=>params[:page],:conditions => "product_id = #{@product.id}",:order=>'created_at asc',:per_page =>2
    @comment = Comment.new    

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    # @product = Product.new(params[:product])
      # if request.get?
      @product = Product.new(params[:product])   
         
      @filename = save_file
      if @filename != nil 
          @product.image_url = "/uploads/#{@filename}"  
      else
          @product.image_url = "/images/logo.png"  
      end
    # else
      # @product = Product.new(params[:product]) 
    # end


    respond_to do |format|
      if @product.save
        format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])    
    @filename = save_file
     if @filename != nil 
        @product.image_url = "/uploads/#{@filename}"  
     end
     
     respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
     end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end
  
  def who_bought
    @product = Product.find(params[:id])
    respond_to do |format|
      format.atom
      format.xml {render :xml => @product}
    end
  end
  
   ############################################################################
  def configure_charsets  
     @headers["Content-Type"]="text/html;charset=utf-8" 
   end       
 
  def upload_file(file)  
     unless file.original_filename.empty?
       @filename=get_file_name(file.original_filename)   
       File.open("#{RAILS_ROOT}/public/uploads/#{@filename}", "wb") do |f|  
       f.write(file.read)  
       end  
       return @filename 
     end  
   end 
   
   def get_file_name(filename)  
     unless filename.nil?  
       Time.now.strftime("%Y%m%d%H%M%S") + '_' + filename  
     end  
   end  
 
   def save_file
     if params[:file] == nil
       return nil
     end
     
     if request.get? == false 
     # unless params[:file]['file'].original_filename.empty?
       if filename=upload_file(params[:file]['file'])  
         return filename  
       end  
     end 
      
   end  
end
  ############################################################################


