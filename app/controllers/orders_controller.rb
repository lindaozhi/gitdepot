class OrdersController < ApplicationController
  skip_before_filter :authorize, :only => [:create]
  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.paginate :page=>params[:page], :order=>'created_at desc',:per_page =>10,:conditions => "orderstatus=0"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end
  
  def index_record
    @user = User.find(session[:user_id])
    @orders = Order.paginate :page=>params[:page], :order=>'created_at desc',:per_page =>2,:conditions => ["user_name = ? and orderstatus = ?",@user.name,0]

    #@orders = Order.find(:all,:conditions=>"user_name='#{@user.name}'")   
    
    
    respond_to do |format|
      format.html # index_record.html.erb
      format.xml  { render :xml => @orders }
    end
  end
  
  def ordersrecord
     @orders = Order.paginate :page=>params[:page], :order=>'created_at desc',:per_page =>10,:conditions => "orderstatus<>0"
     #@orders = Order.all
     
     respond_to do |format|
      format.html # ordersrecord.html.erb
      format.xml  { render :xml => @orders }
    end
  end
  
  def userorderrecord
     @user = User.find(session[:user_id])
     @orders = Order.paginate :page=>params[:page], :order=>'created_at desc',:per_page =>2,:conditions => ["user_name = ? and orderstatus <>?",@user.name,0]
     
    respond_to do |format|
      format.html #  userorderrecord.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @user = User.find(session[:user_id])
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end
  
  def sendorder
    @user = User.find(session[:user_id])
    @order = Order.find(params[:id])
    @order.orderstatus = 1
    for lineItem in @order.line_items
      @product = Product.find(lineItem.product_id)
      @product.inventory -= lineItem.quantity
      @product.sales += lineItem.quantity
      @product.save
    end
    if @order.save
      Notifier.order_shipped(@order).deliver
    end
    
    #用于自动跳转到自己的view
    # respond_to do |format|
      # format.html # sendorder.html.erb
      # format.xml  { render :xml => @order }
    # end
    
    #redirect_to :controller=>"orders",:action => "index"
    redirect_to orders_url
  end
  
  def cancelorder
    @user = User.find(session[:user_id])
    @order = Order.find(params[:id])
    @order.orderstatus = 2
    if @order.save
      Notifier.order_shipped(@order).deliver
    end
    redirect_to orders_url
  end
  
  # GET /orders/new
  # GET /orders/new.xml
  def new
    if current_cart.line_items.empty?
      redirect_to store_url, :notice => "Your cart is empty"
      return
    end
    @order = Order.new
    #@user = User.find(session[:user_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @user = User.find(session[:user_id])
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(current_cart)
    
    @user = User.find(session[:user_id])
   # @order.user_name = @user.get_username(session[:user_id])
    #@order.user_name = @user.name
    @order.user_name = @user.get_username
    @order.orderstatus = 0
    
    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id]=nil
        Notifier.order_received(@order).deliver
        format.html { redirect_to(store_url, :notice => I18n.t('.thanks')) }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to(@order, :notice => 'Order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
end
