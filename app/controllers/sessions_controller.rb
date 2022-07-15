class SessionsController < ApplicationController
  def new
    redirect_url = params[:redirect_url] || root_url
    return render :nothing => true, :status => :bad_request if not allowed? redirect_url
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    redirect_to redirect_url, allow_other_host: true if not @current_user.nil?
  end
  
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_url = params[:redirect_url] || root_url
      return render :nothing => true, :status => :bad_request if not allowed? redirect_url
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
      return redirect_to redirect_url, allow_other_host: true if not @current_user.nil?
    else
      flash.now.alert = "Email or password is invalid"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end

  private 
  def allowed?(url)
    allowed_hosts = [
      request.protocol + request.host_with_port,
      'http://localhost:3001'
    ]
    allowed_hosts.any? do |host|
      url.start_with?(host)
    end
  end
end
