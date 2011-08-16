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
    @cart = current_cart
    @search_name = params[:search_name]
    if params[:search_name] == nil       
       redirect_to store_url, :notice => "Sorry please enter key words"
    else    
      if params[:order] == "price"        
         @products = Product.find_by_sql("select* from Products where title like '%"\
         +params[:search_name]+"%' or description like '%"+params[:search_name]+"%' order by price" )
      else 
         @products = Product.find_by_sql("select* from Products where title like '%"\
         +params[:search_name]+"%' or description like '%"+params[:search_name]+"%' order by title" )
      end    
     end  
    end
end
