# apns_cert = Rails.env.production? ? ENV['APNS_CERT'] : Rails.application.secrets[:apns_cert]
# options = {
#     url: Rails.application.secrets[:apns_url],
#     cert_path: StringIO.new(apns_cert)
# }
# size = Rails.application.secrets[:apns_connection_pool_size]
# NotificationPushService.connection_pool = Apnotic::ConnectionPool.new(options, size: size)