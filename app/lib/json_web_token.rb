class JsonWebToken
    SECRET_KEY = Rails.application.secrets.secret_key_base. to_s
    PRIVATE_KEY = OpenSSL::PKey::RSA.new ENV["PRIVATE_KEY"]
    PUBLIC_KEY = OpenSSL::PKey::RSA.new ENV["PUBLIC_KEY"]
  
    def self.external_encode(payload, exp = 1.months.from_now)
      payload[:exp] = exp.to_i
      payload[:iss] = 'authentication'
      JWT.encode(payload, PRIVATE_KEY, 'RS256')
    end

    def self.external_decode(token)
      decoded = JWT.decode(token, PUBLIC_KEY, true, { algorithm: 'RS256' })
      HashWithIndifferentAccess.new decoded
    end

    def self.encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end
  
    def self.decode(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    end
  end