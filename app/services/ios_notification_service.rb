class IosNotificationService
  @connection_pool = nil

  class << self
    attr_accessor :connection_pool
    
    def send_me(message)
      connection = establish_connection
      connection.open
      connection.write(message)
      puts connection
      puts message
      connection.close
    end
  
    private
 
    def establish_connection
      apns_gateway = "apn://gateway.push.apple.com:2195"
      if Rails.env.production?
        path = Rails.root.join('config', 'server_certificates_bundle_sandbox_new.pem')
      else
        path = Rails.root.join('config', 'apns-dev.pem')
      end
      certificate = File.read(path)
      # Houston::Connection.new(Houston::APPLE_DEVELOPMENT_GATEWAY_URI, certificate, ENV['APPLE_PUSH_NOTIFICATION_PASS'])
      Houston::Connection.new(Houston::APPLE_PRODUCTION_GATEWAY_URI, certificate, ENV['APPLE_PUSH_NOTIFICATION_PASS'])
    end
  end
end