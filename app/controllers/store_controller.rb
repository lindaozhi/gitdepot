class StoreController < ApplicationController
  skip_before_filter :authorize
  
  def index
    if params[:set_locale]
      redirect_to store_path(:locale => params[:set_locale])
    else
       @products = Product.paginate :page=>params[:page], :order=>'created_at desc',:per_page =>3
       @cart = current_cart
    end
    
  end
  
   def show_search
    @search_name = params[:search_name]
    if params[:search_name] == nil       
       redirect_to store_url, :notice => "Sorry please enter key words"
    else    
      if params[:order] == "price"
         # @products = Product.paginate :page=>params[:page], :order=>'price asc',:per_page =>3,
         # :conditions => ["title like %#{params[:search_name]}%","description like %%#{params[:search_name]}%%"]
         @products = Product.find_by_sql("select* from Products where title like '%"\
         +params[:search_name]+"%' or description like '%"+params[:search_name]+"%' order by price" )
      else 
          # @products = Product.paginate :page=>params[:page], :order=>'title asc',:per_page =>3,
         # :conditions => ["title like %?% or description like %?%",params[:search_name],params[:search_name]]
         @products = Product.find_by_sql("select* from Products where title like '%"\
         +params[:search_name]+"%' or description like '%"+params[:search_name]+"%' order by title" )
       end      
       
       @cart = current_cart
    end
  end


end
