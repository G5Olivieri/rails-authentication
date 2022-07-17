class SessionsController < ApplicationController
  before_action :redirect_uri, only: [:new, :create]
  before_action :client_id, only: [:new, :create]
  before_action :response_type, only: [:new, :create]
  before_action :validate_client, only: [:new, :create]

  def new
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    unless @current_user.nil?
      jwt = JsonWebToken.encode({ sub: @current_user.id }, 30.seconds.from_now)
      redirect_to @redirect_uri + "?code=#{jwt}",  allow_other_host: true
    end
  end
  
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
      unless @current_user.nil?
        jwt = JsonWebToken.encode({ sub: @current_user.id }, 30.seconds.from_now)
        redirect_to @redirect_uri + "?code=#{jwt}",  allow_other_host: true
      end
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
  def is_client_valid?(client)
    allowed_clients = [
      { client_id: 'subscriptions', redirect_uri: 'http://localhost:3001/api/callback' },
    ]

    allowed_clients.any? do |valid_client|
      valid_client[:client_id] == client[:client_id] && client[:redirect_uri] == valid_client[:redirect_uri]
    end
  end

  def validate_client
    client = {client_id: @client_id, redirect_uri: @redirect_uri }
    render html: '', status: :unauthorized unless is_client_valid? client
  end

  def redirect_uri
    @redirect_uri = (params[:redirect_uri] || root_url).split('?', 2)[0]
  end

  def response_type
    @response_type = params[:response_type]
    render html: '', status: :bad_request unless @response_type == 'code'
  end

  def client_id
    @client_id = params[:client_id]
  end
end
