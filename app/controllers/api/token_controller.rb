class Api::TokenController < ActionController::API
  before_action :redirect_uri, only: [:create]
  before_action :client_id, only: [:create]
  before_action :grant_type, only: [:create]
  before_action :validate_client, only: [:create]

    def create
        begin
            payload = JsonWebToken.decode(params[:code])
            user = User.find(payload[:sub])
            if user
              jwt = JsonWebToken.external_encode({ sub: user.id, email: user.email, aud: @client_id })
              return render json: { access_token: jwt }
            else
                return render json: {}, status: :unauthorized
            end
        rescue
            return render json: {} , status: :unauthorized
        end
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
    client = { client_id: @client_id, redirect_uri: @redirect_uri }
    render html: 'is not valid redirect_uri', status: :unauthorized unless is_client_valid? client
  end

  def redirect_uri
    @redirect_uri = (params[:redirect_uri] || root_url).split('?', 2)[0]
  end

  def grant_type
    @grant_type = params[:grant_type]
    render html: @grant_type, status: :bad_request unless @grant_type == 'authorization_code'
  end

  def client_id
    @client_id = params[:client_id]
  end
end
