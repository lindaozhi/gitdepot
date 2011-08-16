class SessionsController < ApplicationController
  skip_before_filter :authorize
  
  def new
  end

  def create
    if user = User.authenticate(params[:name],params[:password])
      session[:user_id] = user.id
      session[:user_type] = user.user_type
      if(user.user_type == 1)
        redirect_to admin_url
      else
        redirect_to store_url
      end
    else
      redirect_to login_url, :notice => "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_type] = nil
    redirect_to store_url,:notice => "Logged out"
  end
end
