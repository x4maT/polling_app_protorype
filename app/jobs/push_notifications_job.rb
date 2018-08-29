class PushNotificationsJob < ApplicationJob
 
 def perform(notification)
  connection = establish_connection
  connection.open
  connection.write(notification.message)
  connection.close
 end
  
 private
 
 def establish_connection
  certificate = File.read("config/apns-dev.pem")
   Houston::Connection.new(
  Houston::APPLE_DEVELOPMENT_GATEWAY_URI, certificate, ENV['APPLE_PUSH_NOTIFICATION_PASS']
 )
 end
end